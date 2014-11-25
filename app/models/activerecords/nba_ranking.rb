class NBA_Ranking < ActiveRecord::Base
  default_scope {where("TO_DATE(game_date,'MM/DD/YYYY') = TO_DATE(?, 'DD/MM/YYYY')", NBA_Lineup.current_date )}
  scope :position, lambda{|pos| where("position IN (?)", pos )}
  scope :site, lambda{|site| where("upper(website) = ?", site )}
  scope :salary_lte, lambda{|fd| where("salary <= ?", fd )}
  scope :min_fd_score, lambda{|fd| where("fd_score > ?", fd )}
  scope :min_ppd, lambda{|fd| where("(fd_score / (salary / 1000)) > ?", fd )}
  scope :day, lambda{|day| where("TO_DATE(game_date,'MM/DD/YYYY') = TO_DATE(?, 'DD/MM/YYYY')", day )}
  
end
