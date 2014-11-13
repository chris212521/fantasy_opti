class Lineup
  attr_accessor :site, :max_salary, :players, :optimal_lineup
  attr_reader :positions, :league_name, :working_pos
  
  def initialize( args )
    @site = args[:site]
    @max_salary = args[:max_salary]
    self.positions=(args[:pos])
    @working_pos = self.groom_positions(@positions)
    
    post_init(args)
    
    self.set_players
  end
  
  #subclasses may override
  def post_init(args)
    nil
  end
  
  def self.site_positions(site)
    if site == 'DK'
       dk_positions
     elsif site == 'FD'
       fd_positions
     elsif site == 'V'
       dk_positions
    end
  end
  
  def site_positions(site)
    if site == 'DK'
       dk_positions
     elsif site == 'FD'
       fd_positions
    end
  end
  
  def positions=( p )#position1, position2, position3=nil, position4=nil )
      @positions = p.delete_if(&:nil?)
 
  end
  
  def possible_lineups
    #returns all possible combinations, with respect to parameters (salary, positions)
     possibles = []
     legitimate = []
     
     @working_pos.each_with_index do |item, index|
            if index == 0
              puts item
              possibles = @players.select{|r| @working_pos[index].include?(r.position)} 
              puts possibles.count
            else 
              puts item
              possibles = possibles.product(@players.select{|r| @working_pos[index].include?(r.position)}).map(&:flatten)
              puts possibles.count
              #delete now so we don't need to create more lineups than needed
              if index.odd?
                possibles.delete_if {|x| x.uniq.count != x.count }
                puts possibles.count
              end
              

            end
        end
        
      possibles.each do |lineup|  
         #get players in order so we can use uniq later to filter dupes that were created in different order
         lineup = lineup.sort_by(&:player_name).sort_by {|o| @working_pos.flatten.index(o.position) || 99}
         (lineup.sum(&:salary) <= @max_salary) ? legitimate << lineup : nil # and (lineup.uniq.count == lineup.count)
        end
        
        legitimate
  end
end