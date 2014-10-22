class Util
  def self.groom_position(pos, league)
    pos.upcase == 'FLEX' ? pos = get_league_class(league).flex_pos : pos = pos.upcase
  end

  def self.supported_sites
    ['DK','FD','V']
  end
  
  def self.get_league_class( name )
    if name == 'NFL'
      NFL.new
    elsif name == 'NBA'
      NBA.new
    end
  end
  
  def self.get_current_date ( league )
    get_league_class(league).current_date
  end
  
end