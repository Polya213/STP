module UnitConverter
  MULTIPLIERS = {kg: 1000, g: 1, l: 1000, ml: 1, pcs: 1}
  def self.to_base(qty, unit)
    raise 'Cannot convert' unless MULTIPLIERS.key?(unit)
    qty * MULTIPLIERS[unit]
  end
end
