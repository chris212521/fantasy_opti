class Player

  def self.set_players( lineup )
    puts 'set players'
    #will probably need different DB calls based on league unless everything goes to the same view
     if lineup.league_name == 'NFL'
       lineup.players = Opti_Ranking.week(lineup.league.current_date).site(lineup.site).exclude_day(lineup.excluded_days).league(lineup.league_name).all
     elsif lineup.league_name == 'NBA'
       lineup.players = NBA_Ranking.site(lineup.site).all
     end
     
  #NBA needs to combine salaries and our 5 game average
  
  end
  
end