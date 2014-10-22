class NBA_Ranking < ActiveRecord::Base
  default_scope {where("TO_DATE(game_date,'MM/DD/YYYY') = ?", NBA.current_date )}
  scope :position, lambda{|pos| where("position IN (?)", pos )}
  scope :site, lambda{|site| where("upper(website) = ?", site )}
  scope :min_ppd_fd, lambda{|ppd| where("ppd_fd > ?", ppd )}
  scope :top_ppd_fd, -> { order("ppd_fd DESC") }
  
end
