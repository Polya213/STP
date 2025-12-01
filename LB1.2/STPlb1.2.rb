def play_game
  number = rand(1..100)
  attempts = 0

  loop do
    print "Введи число: "
    guess = gets.to_i
    attempts += 1

    if guess < number
      puts "Більше"
    elsif guess > number
      puts "Менше"
    else
      puts "Вгадано!"
      puts "Кількість спроб: #{attempts}"
      break
    end
  end
end

play_game
