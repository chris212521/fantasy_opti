class Opti_Ranking < ActiveRecord::Base
  default_scope {where("year = ?", NFL.current_year )}
  scope :position, lambda{|pos| where("position IN (?)", pos )}
  scope :year, lambda{|year| where("year = ?", year )}
  scope :week, lambda{|week| where("week = ?", week )}
  scope :site, lambda{|site| where("upper(website) = ?", site )}
  scope :min_ppd_std, lambda{|ppd| where("ppd_std > ?", ppd )}
  scope :min_ppd_ppr, lambda{|ppd| where("ppd_ppr > ?", ppd )}
  scope :top_ppd_std, -> { order("ppd_std DESC") }
  scope :top_ppd_ppr, -> { order("ppd_ppr DESC") }
  scope :top_std_proj, -> { order("std_proj DESC") }
  scope :top_ppr_proj, -> { order("ppr_proj DESC") }
  
end
