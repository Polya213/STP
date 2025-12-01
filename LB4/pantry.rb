require_relative 'unit_converter'
class Pantry
  def initialize
    @storage = {}
  end
  def add(name, qty, unit)
    qty_base = UnitConverter.to_base(qty, unit)
    if @storage.key?(name)
      @storage[name][:qty] += qty_base
    else
      @storage[name] = {qty: qty_base, unit: unit}
    end
  end
  def available_for(name)
    @storage[name] ? @storage[name][:qty] : 0
  end
end
