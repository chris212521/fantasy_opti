class Player
  
  def self.set_players( lineup )
     lineup.players = Opti_Ranking.week(lineup.league.current_date).site(lineup.site).exclude_day(lineup.excluded_days).league(lineup.league.league_name).all
  end
  
end