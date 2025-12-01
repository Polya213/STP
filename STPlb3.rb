require 'find'
require 'digest'
require 'json'
require 'csv'

# ------------------------
# Збір всіх файлів
# ------------------------
def scan_files(root)
  files = []

  Find.find(root) do |path|
    next unless File.file?(path)

    begin
      stat = File.stat(path)
      files << {
        path: path,
        size: stat.size,
        inode: stat.ino
      }
    rescue
      next
    end
  end

  files
end

# ------------------------
# Групування за розміром
# ------------------------
def group_by_size(files)
  files.group_by { |f| f[:size] }
end

# ------------------------
# Побайтне підтвердження дублікатів
# ------------------------
def confirm_duplicates(group)
  return [] if group.size < 2

  hash_groups = {}

  group.each do |file|
    begin
      md5 = Digest::MD5.file(file[:path]).hexdigest
      hash_groups[md5] ||= []
      hash_groups[md5] << file[:path]
    rescue
      next
    end
  end

  hash_groups.values.select { |g| g.size > 1 }
end

# ------------------------
# Формування результату
# ------------------------
def find_duplicates(root)
  files = scan_files(root)
  size_groups = group_by_size(files)

  duplicate_groups = []

  size_groups.each do |size, group|
    confirmed = confirm_duplicates(group)
    confirmed.each do |dups|
      duplicate_groups << {
        size_bytes: size,
        saved_if_dedup_bytes: size * (dups.size - 1),
        files: dups
      }
    end
  end

  {
    scanned_files: files.size,
    groups: duplicate_groups
  }
end

# ------------------------
# Запис у CSV
# ------------------------
def write_csv(duplicates, filename = "duplicates.csv")
  CSV.open(filename, "w", write_headers: true, headers: ["size_bytes", "saved_if_dedup_bytes", "file"]) do |csv|
    duplicates[:groups].each do |group|
      group[:files].each do |file|
        csv << [group[:size_bytes], group[:saved_if_dedup_bytes], file]
      end
    end
  end
end

# ------------------------
# Запуск
# ------------------------
root_path = ARGV[0] || "."   # директорія для сканування
result = find_duplicates(root_path)

# JSON
File.write("duplicates.json", JSON.pretty_generate(result))
# CSV
write_csv(result)

puts "Сканування завершено!"
puts "Знайдено груп дублікатів: #{result[:groups].size}"
puts "Результат у файлах duplicates.json та duplicates.csv"
