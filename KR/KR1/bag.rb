require 'csv'
require 'date'

class Bag
  include Enumerable

  def initialize(items = [])
    @items = items.to_a
  end

  def <<(item)
    @items << item
    self
  end

  def size
    @items.size
  end

  def each(&block)
    return enum_for(:each) unless block_given?
    @items.each(&block)
    self
  end

  def frequencies
    freq = Hash.new(0)
    each { |e| freq[e] += 1 }
    freq
  end

  def median
    return nil if size == 0
    sorted = @items.sort
    mid = size / 2
    if size.odd?
      sorted[mid]
    else
      left, right = sorted[mid - 1], sorted[mid]
      numeric?(left) && numeric?(right) ? (left + right) / 2.0 : left
    end
  end

  private

  def numeric?(obj)
    obj.is_a?(Numeric)
  end
end

CASTERS = {
  int: ->(v) { Integer(v) rescue nil },
  decimal: ->(v) { Float(v) rescue nil },
  time: ->(v) { DateTime.parse(v) rescue nil },
  string: ->(v) { v.to_s }
}

def parse_csv_stream(file_path, headers: true, column_types: {})
  CSV.foreach(file_path, headers: headers) do |row|
    parsed_row = {}
    row.each do |header, value|
      caster_key = column_types[header.to_sym] || :string
      caster = CASTERS[caster_key]
      parsed_row[header] = caster.call(value)
    end
    yield parsed_row
  end
end
if __FILE__ == $0
  puts "=== Тест Bag ==="
  b = Bag.new([3, 1, 4, 1, 5])
  b << 9
  puts "Розмір мішка: #{b.size}"
  puts "Частоти: #{b.frequencies}"
  puts "Медіана: #{b.median}"
  puts "Подвоєні елементи: #{b.map { |x| x * 2 }}"

  puts "\n=== Тест CSV-парсер ==="
  csv_file = 'example.csv'
  CSV.open(csv_file, 'w') do |csv|
    csv << %w[id price created_at name]
    csv << [1, 12.5, '2025-10-23 22:30', 'Item A']
    csv << [2, 23.0, '2025-10-24 10:15', 'Item B']
    csv << [3, 5.75, '2025-10-24 12:00', 'Item C']
  end

  column_types = { id: :int, price: :decimal, created_at: :time }

  parse_csv_stream(csv_file, headers: true, column_types: column_types) do |row|
    puts row.inspect
  end
end
