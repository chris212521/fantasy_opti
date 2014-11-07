class NBA_Best < ActiveRecord::Base
  scope :position, lambda{|pos| where("position IN (?)", pos )}
  scope :site, lambda{|site| where("upper(website) = ?", site )}
  scope :day, lambda{|day| where("TO_DATE(game_date,'MM/DD/YYYY') = TO_DATE(?, 'DD/MM/YYYY')", day )}
end
