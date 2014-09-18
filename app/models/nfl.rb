class NFL
  @@season_year = 2013
  
  def self.update_week_projections(num=nil)
    positions = ['QB','RB','WR','TE','K','DEF']
    
      positions.each do |pos|
          position_proj = FFNerd.weekly_rankings(pos, num)
      
          position_proj.each do |p|
            Projection.create(player_name: p.name, player_id: p.playerId, position: p.position, team: p.team, std_proj: p.standard,
                              std_low_proj: p.standardLow, std_high_proj: p.standardHigh, ppr_proj: p.ppr, ppr_low_proj:  p.pprLow,
                              ppr_high_proj: p.pprHigh, injury: p.injury, practice_status: p.practiceStatus, game_status: p.gameStatus,
                              last_update: p.lastUpdate, week: p.week, year: @@season_year)
      end
    
    end
    
    
    #t.string :player_name
    #  t.integer :player_id
    #  t.string :position
    #  t.string :team
    #  t.decimal :std_proj
    #  t.decimal :std_low_proj
    #  t.decimal :std_high_proj
   #   t.decimal :ppr_proj
   #   t.decimal :ppr_low_proj
   #   t.decimal :ppr_high_proj
   #   t.string :injury
    #  t.string :practice_status
   #   t.string :game_status
   #   t.string :last_update
   #   t.integer :week
   #   t.integer :year
      
  end
end