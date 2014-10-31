class NBA_last_five_avg < ActiveRecord::Base
  scope :position, lambda{|pos| where("position IN (?)", pos )}
  scope :site, lambda{|site| where("upper(website) = ?", site )}
  scope :week, lambda{|week| where("week = ?", week )}
end
