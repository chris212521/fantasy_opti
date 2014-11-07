class Projection < ActiveRecord::Base
  default_scope {where("year = ?", NFL_Lineup.current_year )}
  scope :position, lambda{|pos| where("position IN (?)", pos )}
  scope :year, lambda{|year| where("year = ?", year )}
  scope :week, lambda{|week| where("week = ?", week )}
  scope :top_std_proj, -> { order("std_proj DESC") }
end
