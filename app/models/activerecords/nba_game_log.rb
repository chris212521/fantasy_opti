class NBA_Game_Log < ActiveRecord::Base
  def self.save_game_logs( logs )
    logs.each do |x|
            NBA_Game_Log.create(
                                  player_name: x.player_name,
                                  game_date: x.game_date,
                                  team_name: x.team_name,
                                  opponent_name: x.opponent_team,
                                  minutes_played: x.minutes_played,
                                  fgm: x.fgm,
                                  fga: x.fga,
                                  fg_pct: x.fga == '0' ? nil : (x.fgm.to_f/x.fga.to_f).round(3),
                                  tpm: x.tpm,
                                  tpa: x.tpa,
                                  tp_pct: x.tpa == '0' ? nil : (x.tpm.to_f/x.tpa.to_f).round(3),
                                  ftm: x.ftm,
                                  fta: x.fta,
                                  ft_pct: x.fta == '0'? nil : (x.ftm.to_f/x.fta.to_f).round(3),
                                  orb: x.orb,
                                  drb: x.drb,
                                  trb: (x.orb.to_i + x.drb.to_i),
                                  assists: x.assists,
                                  steals: x.steals,
                                  blocks: x.blocks,
                                  tov: x.tov,
                                  #pf: x.pf||=nil,
                                  points: x.points
                                  #game_score: x.game_score||=nil
                                  )
    end
  end
end