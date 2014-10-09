class Difference < ActiveRecord::Base
  default_scope {where("year = ?", NFL.current_year )}
  scope :position, lambda{|pos| where("position IN (?)", pos )}
  scope :year, lambda{|year| where("year = ?", year )}
  scope :week, lambda{|week| where("week = ?", week )}
  
end
