class Opti_Ranking < ActiveRecord::Base
  default_scope {where("year = ?", NFL.current_year )}
  scope :position, lambda{|pos| where("position IN (?)", pos )}
  scope :year, lambda{|year| where("year = ?", year )}
  scope :week, lambda{|week| where("week = ?", week )}
  scope :min_ppd, lambda{|ppd| where("ppd_std > ?", ppd )}
  scope :top_ppd_std, -> { order("ppd_std DESC") }
  scope :top_std_proj, -> { order("std_proj DESC") }
  
end
