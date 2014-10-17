class Util
  def self.groom_position(pos)
    pos.upcase == 'FLEX' ? pos = NFL.flex_pos : pos = pos.upcase
  end
  
  def self.update_NFL_week_projections(num=nil)
    #these are special for FFN API
    positions = ['QB','RB','WR','TE','K','DEF']
    
      positions.each do |pos|
          position_proj = FFNerd.weekly_rankings(pos, num)
      
          position_proj.each do |p|
            Projection.create(player_name: p.name, player_id: p.playerId, position: p.position, team: p.team, std_proj: p.standard,
                              std_low_proj: p.standardLow, std_high_proj: p.standardHigh, ppr_proj: p.ppr, ppr_low_proj:  p.pprLow,
                              ppr_high_proj: p.pprHigh, injury: p.injury, practice_status: p.practiceStatus, game_status: p.gameStatus,
                              last_update: p.lastUpdate, week: p.week, year: NFL.current_year)
      end
    ActiveRecord::Base.connection.execute('SELECT update_rankings('+NFL.current_week.to_s+','+NFL.current_year.to_s+', \'FD\')')
    ActiveRecord::Base.connection.execute('SELECT update_rankings('+NFL.current_week.to_s+','+NFL.current_year.to_s+', \'DK\')')
    ActiveRecord::Base.connection.execute('SELECT update_rankings('+NFL.current_week.to_s+','+NFL.current_year.to_s+', \'V\')')
    end      
  end
  
  def self.supported_sites
    ['DK','FD','V']
  end
  
  def self.get_league_class( name )
    if name == 'NFL'
      NFL.new
    elsif name == 'NBA'
      NBA.new
    end
  end
  
  def self.get_current_date ( league )
    get_league_class(league).current_date
  end
  
end