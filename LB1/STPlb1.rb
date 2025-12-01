def word_stats(text)
  words = text.split

  count_words = words.length
  longest_word = words.max_by(&:length)
  unique_words = words.map(&:downcase).uniq.length

  return count_words, longest_word, unique_words
end
text = "Ruby is fun and ruby is powerful"
count, longest, unique = word_stats(text)

puts "Кількість слів: #{count}"
puts "Найдовше слово: #{longest}"
puts "Унікальних слів: #{unique}"
