module RankingsHelper
  def format_game_teams(opti)
    opti.game_teams.gsub! opti.team, '<b>'+opti.team+'</b>'
  end
end
