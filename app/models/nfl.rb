class NFL
  FFNerd.api_key = "bm37zp5dfhjh"
  @@season_year = 2014
  @@current_week = FFNerd.current_week
  @@flex_pos = ['RB','WR','TE']
  @@positions = ['QB','RB','WR','TE','FLEX','K','DST']
  #FFNerd.current_week
  #FFNerd.schedule.first.gameDate[0,4]
  
  def self.positions
    @@positions
  end
  
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
          
          puts pos
      
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

      #modify FLEX to handle for positions
      if !pos.nil?
      pos.collect! { |element|
        (element == "FLEX") ? NFL.flex_pos : element
        }
      else
        pos = ['QB','WR']
      end
      
      start = Time.new
      
      if pos.count==2
        possibles = arys.select{|r| pos[0].include?(r.position)}.product(arys.select{|r| pos[1].include?(r.position)})
      elsif pos.count==3
        possibles = arys.select{|r| pos[0].include?(r.position)}.product(arys.select{|r| pos[1].include?(r.position)},arys.select{|r| pos[2].include?(r.position)})
      elsif pos.count==4
        possibles = arys.select{|r| pos[0].include?(r.position)}.product(arys.select{|r| pos[1].include?(r.position)},arys.select{|r| pos[2].include?(r.position)},arys.select{|r| pos[3].include?(r.position)})
      elsif pos.count==5
        possibles = arys.select{|r| pos[0].include?(r.position)}.product(arys.select{|r| pos[1].include?(r.position)},arys.select{|r| pos[2].include?(r.position)},arys.select{|r| pos[3].include?(r.position)},arys.select{|r| pos[4].include?(r.position)})
      elsif pos.count==6
        possibles = arys.select{|r| pos[0].include?(r.position)}.product(arys.select{|r| pos[1].include?(r.position)},arys.select{|r| pos[2].include?(r.position)},arys.select{|r| pos[3].include?(r.position)},arys.select{|r| pos[4].include?(r.position)},arys.select{|r| pos[5].include?(r.position)})
      end

     possibles.each do |array_of_players|
        @add_flag = true
        
        if array_of_players.sum(&:salary) > max_sal 
            @add_flag = false
        elsif array_of_players.uniq.count < array_of_players.count
                @add_flag = false
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