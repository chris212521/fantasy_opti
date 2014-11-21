class NBA_Game_Log < ActiveRecord::Base
  def self.save_game_logs( logs )
    logs.each do |d|
  puts d[:minutes_played]
  puts d[:game_date]
            NBA_Game_Log.create(
                                  player_name: d[:player_name],
                                  game_date: d[:game_date],
                                  minutes_played: d[:minutes_played],
                                  fgm: d[:fgm],
                                  fga: d[:fga],
                                  fg_pct: d[:fg_pct],
                                  tpm: d[:tpm],
                                  tpa: d[:tpa],
                                  tp_pct: d[:tp_pct],
                                  ftm: d[:ftm],
                                  fta: d[:fta],
                                  ft_pct: d[:ft_pct],
                                  orb: d[:orb],
                                  drb: d[:drb],
                                  trb: d[:trb],
                                  assists: d[:assists],
                                  steals: d[:steals],
                                  blocks: d[:blocks],
                                  tov: d[:tov],
                                  pf: d[:pf],
                                  points: d[:points],
                                  )
    end
  end
end