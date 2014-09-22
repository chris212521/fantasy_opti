class Ranking < ActiveRecord::Base
  scope :position, lambda{|pos| where("position IN (?)", pos )}
  scope :year, lambda{|year| where("year = ?", year )}
  scope :week, lambda{|week| where("week = ?", week )}
  scope :top_ppd_std, -> { order("ppd_std DESC") }
  scope :top_std_proj, -> { order("std_proj DESC") }
  
end
