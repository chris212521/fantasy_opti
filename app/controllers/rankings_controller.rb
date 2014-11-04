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
    
    if @league == NBA_Lineup
        @diff = Difference.position(@league.groom_position(params[:id].upcase)).game_date(@league.current_date).all
    elsif @league == NFL_Lineup
        @diff = Difference.position(@league.groom_position(params[:id].upcase)).week(@league.current_date).all
    end
    
  end
  
  def rolling_average
    @stats = NBA_last_five_avg.position(params[:id].upcase)
  end
  
  def nba_team_rankings
    @team_rankings = NBA_Team_Ranking.all
  end
  
  def nba_team
    @team = NBA_Team_Ranking.team(params[:team].upcase).first
  end

end
