class NFL

  FFNerd.api_key = "bm37zp5dfhjh"
  @@season_year = 2014
  @@current_week = 6
  @@flex_pos = ['RB','WR','TE']
  @@positions = ['QB','RB','WR','TE','FLEX','K','DST']
  @@dk_positions = ['QB','RB','WR','TE','FLEX','DST']
  @@fd_positions = ['QB','RB','WR','TE','K','DST']
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
  
  def self.fd_positions
    @@fd_positions
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
    ActiveRecord::Base.connection.execute('SELECT update_rankings('+@@current_week.to_s+','+@@season_year.to_s+', \'FD\')')
    ActiveRecord::Base.connection.execute('SELECT update_rankings('+@@current_week.to_s+','+@@season_year.to_s+', \'DK\')')
    ActiveRecord::Base.connection.execute('SELECT update_rankings('+@@current_week.to_s+','+@@season_year.to_s+', \'V\')')
    end      
  end
  
  def self.find_max_option(max_sal, pos, site, exclude_days)
    
    if exclude_days.nil? or exclude_days.empty?
      exclude_days = 'x'
    end

    arys = Opti_Ranking.week(NFL.current_week).site(site).exclude_day(exclude_days).all
    groomed = []
    possibles = []

      #modify FLEX to handle for positions
      #create a new array so FLEX stays for the table header in original
      if !pos.nil?
      pos_groomed = pos.collect { |element|
        (element == "FLEX") ? NFL.flex_pos : element
        }
      end

      pos.each_with_index do |item, index|
          if index == 0
              possibles = arys.select{|r| pos_groomed[index].include?(r.position)}
          else
              possibles = possibles.product(arys.select{|r| pos_groomed[index].include?(r.position)}).map(&:flatten)
          end
      end

    possibles.each do |lineup|  
       #get players in order so we can use uniq later to filter dupes that were created in different order
       #puts pos

       lineup = lineup.sort_by(&:player_name).sort_by {|o| pos_groomed.flatten.index(o.position) || 99}
       
        if (lineup.sum(&:salary) <= max_sal) and (lineup.uniq.count == lineup.count)
          groomed << lineup
        end
      end
      
      #DK is 1 PPR
       return groomed = groomed.sort_by{ |ar| ar.sum(&:ppr_proj) }.reverse.first(20).uniq.first(10)
    end
end