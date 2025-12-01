class Planner
  def self.plan(recipes, pantry, price_list)
    total_calories = 0
    total_cost = 0
    need_hash = Hash.new(0)
    recipes.each do |recipe|
      recipe.need.each do |item|
        need_hash[item[:ingredient].name] += item[:qty]
      end
    end
    need_hash.each do |name, needed|
      have = pantry.available_for(name)
      deficit = [needed - have, 0].max
      unit = recipes.flat_map(&:items).find{|i| i[:ingredient].name==name}[:ingredient].unit
      puts "#{name}: потрібно #{needed}#{unit}, є #{have}#{unit}, дефіцит #{deficit}#{unit}"
      ing = recipes.flat_map(&:items).find{|i| i[:ingredient].name==name}[:ingredient]
      total_calories += needed * ing.calories_per_unit
      total_cost += needed * price_list[name]
    end
    puts "Total calories: #{total_calories}"
    puts "Total cost: #{total_cost.round(2)}"
  end
end
