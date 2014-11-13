class NBA_Day_Best < ActiveRecord::Base
  scope :position, lambda{|pos| where("position IN (?)", pos )}
  scope :site, lambda{|site| where("upper(website) = ?", site )}
  scope :min_fd_score, lambda{|fd| where("fd_score > ?", fd )}
  scope :min_ppd, lambda{|fd| where("(fd_score / (salary / 1000)) > ?", fd )}
  scope :day, lambda{|day| where("TO_DATE(game_date,'YYYY-MM-DD') = TO_DATE(?, 'DD/MM/YYYY')", day )}
  
end
