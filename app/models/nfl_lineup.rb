class NFL_Lineup
  attr_accessor :excluded_days, :site, :salary
  attr_reader :positions
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
  
  def initialize( site=nil, pos=nil, salary=nil, excluded_days=nil )
    @site = site
    self.positions=(pos)
    @salary = salary
    @excluded_days = excluded_days
  end
  
  def positions=(pos)
    @positions = pos.collect { |element|
          (element == "FLEX") ? NFL.flex_pos : element
          }
  end
  
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
  
  def self.pos_to_array(position1, position2, position3=nil, position4=nil)
      p = []
      p.push(position1, position2, position3, position4)
      p.reject!(&:nil?)
  end
  
  def self.groom_excluded_days(thurs, mon)
    ed = []
    if thurs == "0"
        ed << 'Thursday'
      end
      
      if mon == "0"
        ed << 'Monday'
      end
      
      ed.map(&:upcase)
  end
  
  def self.convert_flex_to_pos(positions)
     positions.collect { |element|
          (element == "FLEX") ? NFL.flex_pos : element
          }
  end
  
  def possible_lineups(players)
     possibles = []
     groomed = []
     
     @positions.each_with_index do |item, index|
            if index == 0
                possibles = players.select{|r| @positions[index].include?(r.position)}
            else
                possibles = possibles.product(players.select{|r| @positions[index].include?(r.position)}).map(&:flatten)
            end
        end
        
      possibles.each do |lineup|  
         #get players in order so we can use uniq later to filter dupes that were created in different order
         
         lineup = lineup.sort_by(&:player_name).sort_by {|o| @positions.flatten.index(o.position) || 99}
         
          if (lineup.sum(&:salary) <= @salary) and (lineup.uniq.count == lineup.count)
            groomed << lineup
          end
        end
        
        groomed
  end
  
  def optimal_lineup()
      if @excluded_days.nil? or @excluded_days.empty?
        @excluded_days = 'x'
      end
        
        ary = Opti_Ranking.week(NFL.current_week).site(@site).exclude_day(@excluded_days).all
        possibles = self.possible_lineups(ary)
        
        #DK is 1 PPR
         return possibles.sort_by{ |ar| ar.sum(&:ppr_proj) }.reverse.first(20).uniq.first(10)
    end
    
    def player_pool
        Opti_Ranking.week(NFL.current_week).site(@site).exclude_day(@excluded_days).all
    end
end