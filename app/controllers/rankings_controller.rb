class RankingsController < ApplicationController
  
  def current_rankings
    FFNerd.api_key = "bm37zp5dfhjh"
    if params[:id].upcase == 'FLEX'
      flex_pos = NFL.flex_pos
    end
    
    if flex_pos.nil?
      @rankings = Ranking.position(params[:id].upcase).week(NFL.current_week).site(params[:site].upcase).top_ppd_ppr
    else
      @rankings = Ranking.position(flex_pos).week(NFL.current_week).site(params[:site].upcase).top_ppd_ppr
    end
  end
  
  def optimal_lineup
    #check for params before processing
    if(params.has_key?(:salary) and params.has_key?(:position1))

      @pos = []
      @pos.push(params[:position1],params[:position2],params[:position3],params[:position4])
      @pos.reject!(&:nil?)

      @lineups = NFL.find_max_option(params[:salary].to_i, @pos, params[:site].upcase)

    end
  end

end
