class Lineup
  attr_accessor :site, :max_salary, :league, :players, :optimal_lineup
  attr_reader :positions, :excluded_days, :league_name
  
  def initialize( args )
    @site = args[:site]
    @max_salary = args[:max_salary]
    @league =args[:league]
    
    self.positions=(args[:pos])
    self.excluded_days=(args[:excluded_days])
    Player.set_players(self)
    self.league.optimal_lineup(self)
  end
  
  def positions=( pos )
    @positions = pos.collect { |element|
          (element == "FLEX") ? @league.flex_pos : element
          }
  end
  
  def league_name
    self.league.league_name
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
  
  def self.pos_to_array(position1, position2, position3=nil, position4=nil)
      p = []
      p.push(position1, position2, position3, position4)
      p.delete_if(&:nil?)
  end
  
  def possible_lineups
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
end