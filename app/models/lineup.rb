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
       v_positions
    end
  end
  
  def site_positions(site)
    if site == 'DK'
       dk_positions
     elsif site == 'FD'
       fd_positions
     elsif site == 'V'
       v_positions
    end
  end
  
  def positions=( p )#position1, position2, position3=nil, position4=nil )
      @positions = p.delete_if(&:nil?)
 
  end
  
  def optimal_lineups
    #returns all possible combinations, with respect to parameters (salary, positions)
     possibles = []
     btime = Time.now
     @working_pos.each_with_index do |pos, index|
            if index == 0
              puts pos
              possibles = @players.select{|r| pos.include?(r.position)} 
              puts possibles.count
            else 
              puts pos
              #use "include?" to support array positions (FLEX)
              possibles = possibles.product(@players.select{|r| pos.include?(r.position)}).map(&:flatten) 
              puts possibles.count

              if @working_pos.count(pos) > 1 and index == Hash[@working_pos.map.with_index.to_a][pos] or pos.class() == Array or @site=='DK'
                puts 'REJECTING'
                possibles.reject! {|x| x.uniq.count != x.count }
                possibles.reject! {|x| x.sum(&:salary) > @max_salary }
              end
                
              puts possibles.count 
            end
        end
        
        etime = Time.now
        
        puts "Loop1 elapsed #{(etime - btime)} seconds"  
        possibles.reject! {|x| x.sum(&:salary) > @max_salary }
        possibles.map! {|x| x.sort_by(&:player_name).sort_by {|o| @working_pos.flatten.index(o.position) || 99}}
        

        possibles
  end
  
  def perfect_lineups
    #returns all possible combinations, with respect to parameters (salary, positions)
    puts 'wooooo'
     possibles = []
     btime = Time.now
     @working_pos.each_with_index do |pos, index|
            if index == 0
              puts pos
              possibles = @players.select{|r| pos.include?(r.position)} 
              puts possibles.count
            else 
              puts pos
              #use "include?" to support array positions (FLEX)
              possibles = possibles.product(@players.select{|r| pos.include?(r.position)}).map(&:flatten) 
              puts possibles.count

              if @working_pos.count(pos) > 1 and index == Hash[@working_pos.map.with_index.to_a][pos] or pos.class() == Array or @site=='DK'
                puts 'REJECTING'
                possibles.reject! {|x| x.uniq.count != x.count }
              end
              
              puts possibles.count 
              puts 'league reject'
              
              if league_name == 'NBA'
                possibles.reject! { |e1| possibles.any? { |e2| e1 != e2 and e2.sum(&:salary) <= e1.sum(&:salary) and e2.sum(&:fd_score) > e1.sum(&:fd_score) } }
              elsif league_name == 'NFL'
                possibles.reject! { |e1| possibles.any? { |e2| e1 != e2 and e2.sum(&:salary) <= e1.sum(&:salary) and e2.sum(&:ppr_proj) > e1.sum(&:ppr_proj) } }
              end
                
              puts possibles.count 
            end
        end
        
        etime = Time.now
        
        puts "Loop1 elapsed #{(etime - btime)} seconds"  
        
        possibles.reject! {|x| x.sum(&:salary) > @max_salary }
        possibles.map! {|x| x.sort_by(&:player_name).sort_by {|o| @working_pos.flatten.index(o.position) || 99}}
        

        possibles
  end
end