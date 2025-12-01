#Пошукк прямокутників,що містять 1 родзинку
def find_rectangles(cake, raisin_positions)
  h = cake.size
  w = cake[0].size
  rectangles = []

  raisin_positions.each do |rx, ry|
    (0...rx+1).each do |x1|
      (rx...h).each do |x2|
        (0...ry+1).each do |y1|
          (ry...w).each do |y2|
            #межі прямокутника
            inside = raisin_positions.count { |x, y| x >= x1 && x <= x2 && y >= y1 && y <= y2 }
            rectangles << { x1: x1, y1: y1, x2: x2, y2: y2 } if inside == 1
          end
        end
      end
    end
  end

  rectangles
end
# Перевірка:чи можна вибрати n прямокутників однакової площі
def group_by_area(rectangles, n)
  grouped = rectangles.group_by do |r|
    (r[:x2] - r[:x1] + 1) * (r[:y2] - r[:y1] + 1)
  end

  grouped.values.select { |g| g.size >= n }
end
# Вибір рішення:беремо де перший шматок має найбільшу ширину
def choose_best_solution(groups, cake, raisin_positions)
  best = nil

  groups.each do |rects|
    #беремо по одному прямокутнику на кожну родзинку
    choice = []
    used = {}

    raisin_positions.each do |rx, ry|
      r = rects.find { |rec| rx.between?(rec[:x1], rec[:x2]) && ry.between?(rec[:y1], rec[:y2]) }
      next unless r
      next if used[r]

      used[r] = true
      choice << r
    end

    next if choice.size != raisin_positions.size
    #Сортуємо за шириною першого шматка
    choice.sort_by! { |r| -((r[:y2] - r[:y1] + 1)) }

    best ||= choice
    if (choice[0][:y2] - choice[0][:y1]) > (best[0][:y2] - best[0][:y1])
      best = choice
    end
  end

  best
end
#Вирізання шматків з торта
def cut_pieces(cake, solution)
  solution.map do |r|
    (r[:x1]..r[:x2]).map { |i| cake[i][r[:y1]..r[:y2]] }
  end
end

def cut_cake(cake)
  h = cake.size
  w = cake[0].size
  #Знаходимо всі родзинки
  raisins = []
  cake.each_with_index do |row, i|
    row.chars.each_with_index do |c, j|
      raisins << [i, j] if c == "o"
    end
  end

  n = raisins.size
  #Шукаємо всі можливі прямокутники
  rectangles = find_rectangles(cake, raisins)
  #Групуємо за площею
  possible_groups = group_by_area(rectangles, n)
  #Вибираємо найкращий варіант
  solution = choose_best_solution(possible_groups, cake, raisins)
  #Нарізаємо торт
  cut_pieces(cake, solution)
end

cake = [
  ".о......".tr("о", "o"),
  "......о.".tr("о", "o"),
  "....о...".tr("о", "o"),
  "..о.....".tr("о", "o")
]

result = cut_cake(cake)

result.each_with_index do |piece, i|
  puts "Шматок #{i+1}:"
  piece.each { |row| puts row }
  puts "-"*20
end
