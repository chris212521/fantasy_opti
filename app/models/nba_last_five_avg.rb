class NBA_last_five_avg < ActiveRecord::Base
  scope :position, lambda{|pos| where("position IN (?)", pos )}
end
