module RankingsHelper
  def format_game_teams(opti, league)
    if @league == NBA_Lineup
      teams_array = opti.game_teams.split('@')
      
      teams_array.map! {|t| '<a href=/nba_team/'+t.upcase+'>'+t+'</a>'}
      
      str = teams_array.first + '@' + teams_array.last
      str.gsub! '>'+opti.team+'<', '><b>'+opti.team+'</b><'
    else
      opti.game_teams.gsub! opti.team, '<b>'+opti.team+'</b>'
    end
    
  end

end
