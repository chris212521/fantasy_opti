class NFL_Lineup
  attr_accessor :site, :max_salary
  attr_reader :positions, :excluded_days, :players
  FFNerd.api_key = "bm37zp5dfhjh"
  @@supported_searchable_pos = [2,3,4]
  #FFNerd.current_week
  #FFNerd.schedule.first.gameDate[0,4]
  
  def initialize( site=nil, pos=nil, max_salary=nil, excluded_days=nil )
    @site = site
    self.positions=(pos)
    @max_salary = max_salary
    self.excluded_days=(excluded_days)
    self.set_players
  end
  
  def positions=(pos)
    @positions = pos.collect { |element|
          (element == "FLEX") ? NFL.flex_pos : element
          }
  end
  
  def excluded_days=(a)
    #a = Thurs, Mon
    if a.any?
        ed = []
        a[0] == "0" ? ed << 'THURSDAY' : nil
        a[1] == "0" ? ed << 'MONDAY' : nil
        @excluded_days = ed
     else
        @excluded_days = 'x'
    end
  end
  
  def set_players
     @players = Opti_Ranking.week(NFL.current_week).site(@site).exclude_day(@excluded_days).all
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
  
  def self.convert_flex_to_pos(positions)
     positions.collect { |element|
          (element == "FLEX") ? NFL.flex_pos : element
          }
  end
  
  def possible_lineups()
    #returns all possible combinations, with respect to parameters (salary, positions)
     possibles = []
     groomed = []
     
     @positions.each_with_index do |item, index|
            index == 0 ? possibles = @players.select{|r| @positions[index].include?(r.position)} : possibles = possibles.product(@players.select{|r| @positions[index].include?(r.position)}).map(&:flatten)
        end
        
      possibles.each do |lineup|  
         #get players in order so we can use uniq later to filter dupes that were created in different order
         lineup = lineup.sort_by(&:player_name).sort_by {|o| @positions.flatten.index(o.position) || 99}
         (lineup.sum(&:salary) <= @max_salary) and (lineup.uniq.count == lineup.count) ? groomed << lineup : nil
        end
        
        groomed
  end
  
  def optimal_lineup()
       self.possible_lineups().sort_by{ |ar| ar.sum(&:ppr_proj) }.reverse.first(20).uniq.first(10)
    end
end