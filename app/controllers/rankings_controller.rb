class RankingsController < ApplicationController
  
  def current_rankings
    @league = Util.get_league_class(params[:league].upcase)
  
    @rankings = @league.rankings(position: params[:id].upcase,
                     site: params[:site].upcase)
  end
  
  def optimal_lineup
    @league = Util.get_league_class(params[:league].upcase)
    
    #check for params before processing
    if(params.has_key?(:salary) and params.has_key?(:position1))
      
      if @league == NBA_Lineup
        @lineups = NBA_Lineup.new(
                            site: params[:site].upcase,
                            pos: [params[:position1],params[:position2],params[:position3],params[:position4]],
                            max_salary: params[:salary].to_i
                            )
      elsif @league == NFL_Lineup
        @lineups = NFL_Lineup.new(
                            site: params[:site].upcase,
                            pos: [params[:position1],params[:position2],params[:position3],params[:position4]],
                            max_salary: params[:salary].to_i,
                            excluded_days: [params[:thursday],params[:monday]]
                            )
      end
      
    end
  end
  
  def price_differences
    @league = Util.get_league_class(params[:league].upcase)
    @diff = Difference.position(@league.groom_position(params[:id].upcase)).week(@league.current_date).all
  end
  
  def rolling_average
    @stats = NBA_last_five_avg.position(params[:id].upcase)
  end

end
