class Util

  def self.nfl_supported_sites
    [
     ['DK', 'DraftKings'],
     ['FD', 'FanDuel'],
     ['V', 'Victiv']
    ]
  end
  
  def self.get_league_class( league )
    puts league
    if league == 'NFL'
      NFL_Lineup
    elsif league == 'NBA'
      NBA_Lineup
    end
  end
  
end