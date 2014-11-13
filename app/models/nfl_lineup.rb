class NFL_Lineup < Lineup
    cattr_reader :flex_pos, :current_date, :current_year, :supported_searchable_pos, :dk_positions, :fd_positions, :league_name, :excluded_days, :standard_positions
    
  FFNerd.api_key = "bm37zp5dfhjh"
  @@current_year = 2014
  @@current_date = 11 #week of season
  @@flex_pos = ['RB','WR','TE']
  @@standard_positions = ['QB','RB','WR','TE','FLEX','K','DST']
  @@dk_positions = ['QB','RB','WR','TE','FLEX','DST']
  @@fd_positions = ['QB','RB','WR','TE','K','DST']
  @@supported_searchable_pos = [2,3,4]
  @@league_name = 'NFL'
  #FFNerd.current_week
  #FFNerd.schedule.first.gameDate[0,4]

  def post_init(args)
    puts 'postinit'
    self.excluded_days=(args[:excluded_days])
  end
  
  def excluded_days=( a )
    #a = Thurs, Mon
    puts 'ex d'
    if a.any?
        ed = []
        a[0] == "0" ? ed << 'THURSDAY' : nil
        a[1] == "0" ? ed << 'MONDAY' : nil
        @excluded_days = ed
     else
        @excluded_days = 'x'
    end
  end

  def optimal_lineup
     self.possible_lineups.sort_by{ |ar| ar.sum(&:ppr_proj) }.reverse.first(20).uniq.first(10)
  end
  
  def set_players
    @players = Opti_Ranking.week(@@current_date).site(@site).exclude_day(@excluded_days).league(@@league_name).all
  end
  
  def self.rankings( args )
     Ranking.position(groom_position(args[:position].upcase)).week(NFL_Lineup.current_date).site(args[:site].upcase).top_ppd_ppr
  end
  
  def self.supported_sites
    [
     ['DK', 'DraftKings'],
     ['FD', 'FanDuel'],
     ['V', 'Victiv']
    ]
  end
  
  #this
  def self.groom_position(pos)
    pos.upcase == 'FLEX' ? pos = @@flex_pos : pos = pos.upcase
  end
  
  def groom_positions(pos)
    pos = pos.collect { |element|
          (element == "FLEX") ? @@flex_pos : element
          }
  end
  
end