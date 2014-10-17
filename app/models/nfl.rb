class NFL
  cattr_reader :flex_pos, :positions, :current_date, :current_year, :supported_searchable_pos, :dk_positions, :fd_positions, :league_name
  
  FFNerd.api_key = "bm37zp5dfhjh"
  @@current_year = 2014
  @@current_date = 7 #week of season
  @@flex_pos = ['RB','WR','TE']
  @@positions = ['QB','RB','WR','TE','FLEX','K','DST']
  @@dk_positions = ['QB','RB','WR','TE','FLEX','DST']
  @@fd_positions = ['QB','RB','WR','TE','K','DST']
  @@supported_searchable_pos = [2,3,4]
  @@league_name = 'NFL'
  #FFNerd.current_week
  #FFNerd.schedule.first.gameDate[0,4]
  
  #eventually remove this once we dynamically support >1 league
  def self.positions(site)
    if site == 'DK'
      @@dk_positions
     elsif site == 'FD'
       @@fd_positions
     elsif site == 'V'
       @@dk_positions
    end
  end
  
  def positions(site)
    if site == 'DK'
      @@dk_positions
     elsif site == 'FD'
       @@fd_positions
     elsif site == 'V'
       @@dk_positions
    end
  end

  def optimal_lineup( lineups )
    lineups.sort_by{ |ar| ar.sum(&:ppr_proj) }.reverse.first(20).uniq.first(10)
  end
  
end