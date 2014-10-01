class NFL
  FFNerd.api_key = "bm37zp5dfhjh"
  @@season_year = 2014
  @@current_week = 4
  @@flex_pos = ['RB','WR','TE']
  @@positions = ['QB','RB','WR','TE','FLEX','K','DST']
  @@dk_positions = ['QB','RB','WR','TE','DEF']
  @@supported_searchable_pos = [2,3,4]
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
  
  def self.supported_searchable_pos
    @@supported_searchable_pos
  end
  
  def self.dk_positions
    @@dk_positions
  end
  
  def self.update_week_projections(num=nil)
    #these are special for FFN API
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
  
  def self.find_max_option(max_sal, pos, site)

    arys = Opti_Ranking.week(NFL.current_week).min_ppd_ppr(2).all
    groomed = []
    possibles = []

      #modify FLEX to handle for positions
      if !pos.nil?
      pos.collect! { |element|
        (element == "FLEX") ? NFL.flex_pos : element
        }
      end
      
      pos.each_with_index do |item, index|
          if index == 0
              possibles = arys.select{|r| pos[index].include?(r.position)}
          else
              possibles = possibles.product(arys.select{|r| pos[index].include?(r.position)}).map(&:flatten)
          end
      end

     possibles.each do |array_of_players|
        
        if (array_of_players.sum(&:salary) <= max_sal) and (array_of_players.uniq.count == array_of_players.count)
          groomed << array_of_players          
        end

     end
      
      #DK is 1 PPR
      groomed.max_by{ |ar| ar.sum(&:ppr_proj) }
    end
end