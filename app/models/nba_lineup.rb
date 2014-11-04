class NBA_Lineup < Lineup
    cattr_reader :flex_pos, :current_date, :current_year, :supported_searchable_pos, :dk_positions, :fd_positions, :league_name, :standard_positions
  
  @@league_name = 'NBA'
  @@dk_positions = ['PG','SG','SF','PF','C','G','F','UTIL']
  @@fd_positions = ['PG','SG','SF','PF','C']
  @@standard_positions = ['PG','SG','SF','PF','C']
  @@supported_searchable_pos = [2,3,4,5,6]
  @@current_date = Time.now.strftime("%d/%m/%Y") #Time.new(2014, 11, 1).strftime("%d/%m/%Y")
  
  def self.calc_fd_score( p )
    score = p.tpm*3 + (p.fgm-p.tpm)*2 + p.ftm + p.trb*1.2 + p.assists*1.5 + p.blocks*2 + p.steals*2 - p.tov
  end
  
  def calc_dk_score( p )
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
  
  def optimal_lineup

    if site == 'DK'
      optimal_lineup = possible_lineups.sort_by{ |ar| ar.sum(&:ppd_dk) }.reverse.first(20).uniq.first(10)
    elsif site == 'FD'
      optimal_lineup = possible_lineups.sort_by{ |ar| ar.sum(&:ppd_fd) }.reverse.first(20).uniq.first(10)
    end
    
  end
  
  def set_players
    @players = NBA_Ranking.site(@site).all
  end
  
  def self.rankings( args )
     NBA_Ranking.position(groom_position(args[:position].upcase)).site(args[:site].upcase)
  end
  
  def self.supported_sites
    [
     ['DK', 'DraftKings'],
     ['FD', 'FanDuel']
    ]
  end
  
  def self.groom_position(pos)
    if pos.upcase == 'G'
      pos = ['PG','SG']
    elsif pos.upcase == 'F'
      pos = ['SF','PF']
    elsif pos.upcase == 'UTIL'
      pos = ['PG','SG','SF','PF','C']
    else
      pos = pos.upcase
    end
  end
  
  def groom_positions(pos)
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