class NFL
  FFNerd.api_key = "bm37zp5dfhjh"
  @@season_year = 2014
  @@current_week = FFNerd.current_week
  @@flex_pos = ['RB','WR','TE']
  #FFNerd.current_week
  #FFNerd.schedule.first.gameDate[0,4]
  
  def self.current_week
    @@current_week
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
  
  def self.find_max_option(max_sal, pos)

    arys = Opti_Ranking.week(NFL.current_week).min_ppd('1').all
    groomed = []
    
      qb = arys.select{|r| r.position == 'QB'}
      rb = arys.select{|r| r.position == 'RB'}
      wr = arys.select{|r| r.position == 'WR'}
      te = arys.select{|r| r.position == 'TE'}
      dst = arys.select{|r| r.position == 'DST'}
      f = arys.select{|r| NFL.flex_pos.include?(r.position)}
      start = Time.new
      
      
      
      possibles = f.product(pos[0],pos[1])
      
      
      puts possibles.count

     possibles.each do |array_of_players|
        @add_flag = true
        puts array_of_players.class
        puts array_of_players[0].class
        puts array_of_players[0][0].class
        if array_of_players.sum(&:salary) > max_sal
                @add_flag = false
        else
          #try count of uniq vs original count
          array_of_players.each do |player|
            if array_of_players.count(player) > 1
                @add_flag = false
              end
          end
        end
        
        if @add_flag == true
          groomed << array_of_players
        end
     end
     
     stop = Time.new
      puts "Time elapsed in NFL: #{stop - start} seconds"
      
      groomed.max_by{ |ar| ar.sum(&:std_proj) }
    end

end