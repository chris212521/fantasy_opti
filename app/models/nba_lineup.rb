class NBA_Lineup < Lineup
    cattr_reader :flex_pos, :current_date, :current_year, :supported_searchable_pos, :v_positions, :dk_positions, :fd_positions, :league_name, :standard_positions
  
  @@league_name = 'NBA'
  @@dk_positions = ['PG','SG','SF','PF','C','G','F','UTIL']
  @@fd_positions = ['PG','SG','SF','PF','C']
  @@v_positions = ['G','F','C','SUB']
  @@standard_positions = ['PG','SG','SF','PF','C']
  @@supported_searchable_pos = [2,3,4,5,6,7,8]
  @@current_date = Time.now.strftime("%d/%m/%Y") #Time.new(2014, 11, 1).strftime("%d/%m/%Y")
  
  def self.calc_fd_score( p )
    score = p.points + p.trb*1.2 + p.assists*1.5 + p.blocks*2 + p.steals*2 - p.tov
  end
  
  def self.calc_dk_score( p )
    score = p.points + p.tpm/2 + p.trb*1.25 + p.assists*1.5 + p.steals*2 + p.blocks*2 -p.tov/2
    
    dbl_check = 0
    
    Array.new([p.points, p.trb, p.assists, p.blocks, p.steals]).each do |d|
      if d >=10
        dbl_check = dbl_check + 1
      end
    end
    
    if dbl_check >= 3
      score = score + 3
    elsif dbl_check == 2
      score = score + 1.5
    end
    
    score
    
  end
  
  def self.calc_v_score( p )
    score = p.points + p.trb*1.25 + p.assists*1.25 + p.blocks*2 + p.steals*2 - (p.tov/2)
  end
  
  def optimal_lineup

    if site == 'DK'
      @optimal_lineup = optimal_lineups.sort_by{ |ar| ar.sum(&:dk_score) }.reverse.first(40).uniq.first(20)
    elsif site == 'FD'      
      @optimal_lineup = optimal_lineups.sort_by{ |ar| ar.sum(&:fd_score) }.reverse.first(40).uniq.first(20)
    elsif site == 'V'      
      @optimal_lineup = optimal_lineups.sort_by{ |ar| ar.sum(&:fd_score) }.reverse.first(40).uniq.first(20)
    end
    
  end
  
  def perfect_lineup
      @players = NBA_Day_Best.site(@site).day(Date.yesterday.strftime("%d/%m/%Y"))#Time.new(2014,11,19).strftime("%d/%m/%Y"))

      if site == 'DK'
        @perfect_lineup = perfect_lineups.sort_by{ |ar| ar.sum(&:dk_score) }.reverse.first(1)
      elsif site == 'FD'      
        @perfect_lineup = perfect_lineups.sort_by{ |ar| ar.sum(&:fd_score) }.reverse.first(1)
      elsif site == 'V'      
        @perfect_lineup = perfect_lineups.sort_by{ |ar| ar.sum(&:fd_score) }.reverse.first(1)
    end
  end
  
  def set_players
    @players = NBA_Ranking.site(@site).min_fd_score(10)
  end
  
  def self.rankings( args )
    if args[:site].upcase == 'V'
      if args[:position].upcase == 'SUB'
        NBA_Ranking.position(groom_position(args)).site(args[:site].upcase).salary_lte(5000)
      else
        NBA_Ranking.position(args[:position].upcase).site(args[:site].upcase)
      end
    else
      NBA_Ranking.position(groom_position(args)).site(args[:site].upcase)
    end
     
  end
  
  def self.supported_sites
    [
     ['DK', 'DraftKings'],
     ['FD', 'FanDuel'],
     ['V', 'Victiv']
    ]
  end
  
  def self.groom_position(args)
    if args[:site] == 'V'
        if args[:position].upcase == 'FLEX' or args[:position].upcase == 'SUB'
          args[:position] = ['G','F','C']
        else
          args[:position] = args[:position].upcase
        end
    else
        if args[:position].upcase == 'G'
          args[:position] = ['PG','SG']
        elsif args[:position].upcase == 'F'
          args[:position] = ['SF','PF']
        elsif args[:position].upcase == 'UTIL'
          args[:position] = ['PG','SG','SF','PF','C']
        else 
          args[:position] = args[:position].upcase
        end
    end
  end
  
  def groom_positions(pos)
    if self.site == 'V'
      pos = pos.collect { |element|
          if element.upcase == 'FLEX' or element.upcase == 'SUB'
            element = ['G','F','C']
          else
            element = element.upcase
          end
          }
    else
      pos = pos.collect { |element|
          if element == "G"
            element = ['PG','SG']
          elsif element == "F"
            element = ['PF','SF']
          elsif element == "UTIL"
            element = ['PG','SG','SF','PF','C']
          else
            element = element.upcase
          end
          }
    end
    
  end
  

end