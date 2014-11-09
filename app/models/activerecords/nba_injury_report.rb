class NBA_Injury_report < ActiveRecord::Base
  def self.update_injury_report( reports )
    
    NBA_Injury_report.destroy_all
    
    reports.each do |x|
      unless x.player_name.nil? or x.player_name == ""
            NBA_Injury_report.create(
                                  player_name: x.player_name,
                                  date: x.date,
                                  injury_type: x.type,
                                  injury_note: x.note
                                  )
      end
    end
  end
end