class NBA_Injury_report < ActiveRecord::Base
  def self.update_injury_report( reports )
    
    NBA_Injury_report.destroy_all
    
    reports.each do |x|
            NBA_Injury_report.create(
                                  player_name: x.player_name,
                                  date: x.date,
                                  injury_type: x.type,
                                  injury_note: x.note
                                  )
    end
  end
end