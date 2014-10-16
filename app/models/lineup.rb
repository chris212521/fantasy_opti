class Lineup
  attr_accessor :site, :max_salary, :league
  attr_reader :positions, :excluded_days, :players
  
  def initialize( args )
    @site = args[:site]
    @max_salary = args[:max_salary]
    @league = args[:league]
    
    self.positions=(args[:pos])
    self.excluded_days=(args[:excluded_days])
    self.set_players
  end
  
  def positions=( pos )
    @positions = pos.collect { |element|
          (element == "FLEX") ? NFL.flex_pos : element #need to change this if NBA has flex...
          }
  end
  
  def excluded_days=( a )
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
    @league == 'NFL' ? current_week = NFL.current_week : current_week = nil #need some sort of NBA call here
    
     @players = Opti_Ranking.week(current_week).site(@site).exclude_day(@excluded_days).league(@league).all
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
     legitimate = []
     
     @positions.each_with_index do |item, index|
            if index == 0 
              possibles = @players.select{|r| @positions[index].include?(r.position)} 
            else 
              possibles = possibles.product(@players.select{|r| @positions[index].include?(r.position)}).map(&:flatten)
            end
        end
        
      possibles.each do |lineup|  
         #get players in order so we can use uniq later to filter dupes that were created in different order
         lineup = lineup.sort_by(&:player_name).sort_by {|o| @positions.flatten.index(o.position) || 99}
         (lineup.sum(&:salary) <= @max_salary) and (lineup.uniq.count == lineup.count) ? legitimate << lineup : nil
        end
        
        legitimate
  end
  
  def optimal_lineup()
       self.possible_lineups().sort_by{ |ar| ar.sum(&:ppr_proj) }.reverse.first(20).uniq.first(10)
    end
end