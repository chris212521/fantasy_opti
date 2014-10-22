class RankingsController < ApplicationController
  
  def current_rankings
    FFNerd.api_key = "bm37zp5dfhjh"
      league = params[:league].upcase
      if league == 'NFL'
        @rankings = Ranking.position(Util.groom_position(params[:id].upcase, league)).week(Util.get_current_date(league)).site(params[:site].upcase).top_ppd_ppr
      elsif league == 'NBA'
        # @rankings = Ranking.position(Util.groom_position(params[:id].upcase, league)).week(Util.get_current_date(league)).site(params[:site].upcase).top_ppd_ppr
      end
  end
  
  def optimal_lineup
    #check for params before processing
    if(params.has_key?(:salary) and params.has_key?(:position1))
      @pos = Lineup.pos_to_array(params[:position1],params[:position2],params[:position3],params[:position4])

      @lineups = Lineup.new(
                            site: params[:site].upcase,
                            pos: @pos,
                            max_salary: params[:salary].to_i,
                            excluded_days: [params[:thursday],params[:monday]],
                            league: Util.get_league_class(params[:league].upcase)
                            )
    end
  end
  
  def price_differences
    league = params[:league].upcase
    @diff = Difference.position(Util.groom_position(params[:id].upcase, league)).week(Util.get_current_date(league)).all
  end
  
  def rolling_average
    @stats = NBA_last_five_avg.position(params[:id].upcase)
  end

end
