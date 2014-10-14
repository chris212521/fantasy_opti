class RankingsController < ApplicationController
  
  def current_rankings
    FFNerd.api_key = "bm37zp5dfhjh"
      @rankings = Ranking.position(NFL.groom_position(params[:id].upcase)).week(NFL.current_week).site(params[:site].upcase).top_ppd_ppr
  end
  
  def optimal_lineup
    #check for params before processing
    if(params.has_key?(:salary) and params.has_key?(:position1))
      @pos = NFL_Lineup.pos_to_array(params[:position1],params[:position2],params[:position3],params[:position4])
      @lineups = NFL_Lineup.new(params[:site].upcase,@pos,params[:salary].to_i,[params[:thursday],params[:monday]]).optimal_lineup()
    end
  end
  
  def price_differences
    @diff = Difference.position(Util.groom_position(params[:id].upcase)).week(NFL.current_week).all
  end

end
