class NFL
  @@season_year = 2014
  @@current_week = 3
  #FFNerd.current_week
  #FFNerd.schedule.first.gameDate[0,4]
  
  def self.current_week
    @@current_week
  end
  
  def self.current_year
    @@season_year
  end
  
  def self.update_week_projections(num=nil)
    positions = ['QB','RB','WR','TE','K','DEF']
    FFNerd.api_key = "bm37zp5dfhjh"
    
      positions.each do |pos|
          position_proj = FFNerd.weekly_rankings(pos, num)
      
          position_proj.each do |p|
            Projection.create(player_name: p.name, player_id: p.playerId, position: p.position, team: p.team, std_proj: p.standard,
                              std_low_proj: p.standardLow, std_high_proj: p.standardHigh, ppr_proj: p.ppr, ppr_low_proj:  p.pprLow,
                              ppr_high_proj: p.pprHigh, injury: p.injury, practice_status: p.practiceStatus, game_status: p.gameStatus,
                              last_update: p.lastUpdate, week: p.week, year: @@season_year)
      end
    
    end      
  end
  
  def self.optimal_ranking(all_rankings)
    salary = 50000
    opti_lineup = []
    
    qb = all_rankings.position('QB').first
    opti_lineup << qb
    salary = salary-qb.salary
    
    rb = all_rankings.position('RB').top_std_proj.first
    opti_lineup << rb
    salary = salary-rb.salary
    
    
    rb = all_rankings.position('RB').top_std_proj.first
    opti_lineup << rb
    salary = salary-rb.salary
    
    return opti_lineup, salary
  end
end