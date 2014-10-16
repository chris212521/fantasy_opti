class Opti_Ranking < ActiveRecord::Base
  default_scope {where("year = ?", NFL.current_year )}
  scope :position, lambda{|pos| where("position IN (?)", pos )}
  scope :year, lambda{|year| where("year = ?", year )}
  scope :week, lambda{|week| where("week = ?", week )}
  scope :day, lambda{|day| where("TRIM(to_char(game_date, 'DAY')) IN (?)", day )}
  scope :exclude_day, lambda{|day| where("TRIM(to_char(game_date, 'DAY')) NOT IN (?)", day )}
  scope :site, lambda{|site| where("upper(website) = ?", site )}
  scope :league, lambda{|league| where("upper(league) = ?", league )}
  scope :min_ppd_std, lambda{|ppd| where("ppd_std > ?", ppd )}
  scope :min_ppd_ppr, lambda{|ppd| where("ppd_ppr > ?", ppd )}
  scope :top_ppd_std, -> { order("ppd_std DESC") }
  scope :top_ppd_ppr, -> { order("ppd_ppr DESC") }
  scope :top_std_proj, -> { order("std_proj DESC") }
  scope :top_ppr_proj, -> { order("ppr_proj DESC") }
  
end
