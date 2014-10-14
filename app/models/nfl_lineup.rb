class NFL_Lineup
  attr_accessor :excluded_days, :site, :positions, :salary
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
  
  def initialize( site=nil, positions=nil, salary=nil, excluded_days=nil )
    @site = site
    @positions = positions
    @salary = salary
    @excluded_days = excluded_days
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
  
  def optimal_lineup()
   
      if @excluded_days.nil? or @excluded_days.empty?
        @excluded_days = 'x'
      end
  
      arys = Opti_Ranking.week(NFL.current_week).site(@site).exclude_day(@excluded_days).all
      groomed = []
      possibles = []
  
        #modify FLEX to handle for positions
        #create a new array so FLEX stays for the table header in original
        if !@positions.nil?
        pos_groomed = @positions.collect { |element|
          (element == "FLEX") ? NFL.flex_pos : element
          }
        end
  
        @positions.each_with_index do |item, index|
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
         
          if (lineup.sum(&:salary) <= @salary) and (lineup.uniq.count == lineup.count)
            groomed << lineup
          end
        end
        
        #DK is 1 PPR
         return groomed = groomed.sort_by{ |ar| ar.sum(&:ppr_proj) }.reverse.first(20).uniq.first(10)
    end
end