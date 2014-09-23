class NFL
  FFNerd.api_key = "bm37zp5dfhjh"
  @@season_year = 2014
  @@current_week = FFNerd.current_week
  @@flex_pos = ['RB','WR','TE']
  #FFNerd.current_week
  #FFNerd.schedule.first.gameDate[0,4]
  
  def self.current_week
   3 #@@current_week
  end
  
  def self.current_year
    @@season_year
  end
  
  def self.flex_pos
    @@flex_pos
  end
  
  def self.update_week_projections(num=nil)
    positions = ['QB','RB','WR','TE','K','DEF']
    
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
    exp_pts = 0
    opti_lineup = []
    roster_slots = ['QB','RB','RB','WR','WR','TE','DST', NFL.flex_pos]
    
    roster_slots.each do |rs|
      #selected_player = all_rankings.select{ |r| r.position == rs}.sort!{|a,b| a.ppd_std <=> b.ppd_std}.reverse.first
      selected_player = all_rankings.select{ |r| rs.include?(r.position)}.sort!{|a,b| a.ppd_std <=> b.ppd_std}.reverse.first
      opti_lineup << selected_player
      salary = salary-selected_player.salary
      exp_pts = exp_pts + selected_player.std_proj
      
      
      #we can no longer use them in another slot, so remove
      all_rankings.delete_if{ |r| r==selected_player}
    end
    
    return opti_lineup, salary, exp_pts
  end
  
  def self.find_max_option(max_sal, arys)
    roster_slots = ['QB','RB','RB','WR','WR','TE','DST', NFL.flex_pos]
      a = arys.select{|r| r.position == 'QB'}
      b = arys.select{|r| r.position == 'RB'}
      c = arys.select{|r| r.position == 'WR'}
      d = arys.select{|r| r.position == 'TE'}
      e = arys.select{|r| r.position == 'DST'}
      
      possibles = c.product(a,b,b,c,c)
      groomed = []
      
      possibles.each do |array_of_players|
        
        add_flag = true
          array_of_players.each do |player|
              if array_of_players.count(player) > 1
                add_flag = false
              end
          end
          
        if add_flag == true
          groomed << array_of_players
        end
      end
      
      groomed
      .select{ |arr| arr.reduce(0) { |sum,h| sum + h[:salary] } < max_sal }
      .max_by{ |arr| arr.reduce(0){ |sum,h| sum + h[:std_proj]} }
    end

end