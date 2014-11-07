class Admin
  
  def self.update_NFL_weekly_projections( week=nil )
    Util.update_NFL_week_projections(week)
  end
  
  def self.scrape_NBA_player_games(last_name, first_name, games=nil)
    BBR.download_player_gamelog(last_name, first_name, games)
  end
  
  def self.scrape_NBA_daily_games(month, day, year=2014)
    BBR.daily_boxscores_links(month, day, year)
  end
  
  def self.scrape_NBA_IR
    BBR.injury_report_scraper
  end
  
  def self.nba_team_rankings( team )
    BBR.team_ranking_scraper( team )
  end
  
  def self.update_NFL_week_projections(num=nil)
    #these are special for FFN API
    FFNerd.api_key = "bm37zp5dfhjh"
    positions = ['QB','RB','WR','TE','K','DEF']
    
      positions.each do |pos|
          position_proj = FFNerd.weekly_rankings(pos, num)
      
          position_proj.each do |p|
            Projection.create(player_name: p.name, player_id: p.playerId, position: p.position, team: p.team, std_proj: p.standard,
                              std_low_proj: p.standardLow, std_high_proj: p.standardHigh, ppr_proj: p.ppr, ppr_low_proj:  p.pprLow,
                              ppr_high_proj: p.pprHigh, injury: p.injury, practice_status: p.practiceStatus, game_status: p.gameStatus,
                              last_update: p.lastUpdate, week: p.week, year: NFL_Lineup.current_year)
      end
    ActiveRecord::Base.connection.execute('SELECT update_rankings('+NFL_Lineup.current_date.to_s+','+NFL_Lineup.current_year.to_s+', \'FD\')')
    ActiveRecord::Base.connection.execute('SELECT update_rankings('+NFL_Lineup.current_date.to_s+','+NFL_Lineup.current_year.to_s+', \'DK\')')
    ActiveRecord::Base.connection.execute('SELECT update_rankings('+NFL_Lineup.current_date.to_s+','+NFL_Lineup.current_year.to_s+', \'V\')')
    end      
  end
end