class NBA
  cattr_reader :flex_pos, :positions, :current_date, :current_year, :supported_searchable_pos, :dk_positions, :fd_positions, :league_name
  
  @@positions = ['PG','SG','SF','PF','C']
  @@league_name = 'NBA'
  @@dk_positions = ['PG','SG','SF','PF','C','G','F','UTIL']
  @@fd_positions = @@positions
  @@supported_searchable_pos = [2,3,4]
  @@current_date = Time.new(2014, 10, 28)#Time.now.strftime("%d/%m/%Y")
  
  def self.save_game_logs( logs )
    logs.each do |x|
            NBA_Game_Log.create(
                                  player_name: x.player_name,
                                  game_date: x.game_date,
                                  team_name: x.team_name,
                                  opponent_name: x.opponent_team,
                                  minutes_played: x.minutes_played,
                                  fgm: x.fgm,
                                  fga: x.fga,
                                  fg_pct: x.fga == '0' ? nil : (x.fgm.to_f/x.fga.to_f).round(3),
                                  tpm: x.tpm,
                                  tpa: x.tpa,
                                  tp_pct: x.tpa == '0' ? nil : (x.tpm.to_f/x.tpa.to_f).round(3),
                                  ftm: x.ftm,
                                  fta: x.fta,
                                  ft_pct: x.fta == '0'? nil : (x.ftm.to_f/x.fta.to_f).round(3),
                                  orb: x.orb,
                                  drb: x.drb,
                                  trb: (x.orb.to_i + x.drb.to_i),
                                  assists: x.assists,
                                  steals: x.steals,
                                  blocks: x.blocks,
                                  tov: x.tov,
                                  #pf: x.pf||=nil,
                                  points: x.points
                                  #game_score: x.game_score||=nil
                                  )
    end
  end
  
  def self.calc_fd_score( p )
    score = p.tpm*3 + (p.fgm-p.tpm)*2 + p.ftm + p.trb*1.2 + p.assists*1.5 + p.blocks*2 + p.steals*2 - p.tov
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
  
  def optimal_lineup( lineup )

    if lineup.site == 'DK'
      lineup.optimal_lineup = lineup.possible_lineups.sort_by{ |ar| ar.sum(calc_dk_score(ar)) }.reverse.first(20).uniq.first(10)
    elsif lineup.site == 'FD'
      lineup.optimal_lineup = lineup.possible_lineups.sort_by{ |ar| ar.sum(&:ppd_fd) }.reverse.first(20).uniq.first(10)
    end
    
  end
  
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
    end
  end

end