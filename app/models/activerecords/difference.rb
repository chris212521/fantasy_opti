class Difference < ActiveRecord::Base
  default_scope {where("year = ?", NFL_Lineup.current_year )}
  scope :position, lambda{|pos| where("position IN (?)", pos )}
  scope :year, lambda{|year| where("year = ?", year )}
  scope :week, lambda{|week| where("week = ?", week )}
  scope :game_date, lambda{|game_date| where("TO_DATE(game_date,'MM/DD/YYYY') = TO_DATE(?,'DD/MM/YYYY')", game_date )}
  
end
