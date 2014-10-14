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

      @pos = NFL_Lineup.pos_to_array(params[:position1],params[:position2],params[:position3],params[:position4])

      lineup = NFL_Lineup.new(params[:site].upcase,@pos,params[:salary].to_i,NFL_Lineup.groom_excluded_days(params[:thursday],params[:monday]))
      
      #lineup.positions=(@pos)
    
      @lineups = lineup.optimal_lineup()
    end
  end
  
  def price_differences
    
    if params[:id].upcase == 'FLEX'
      flex_pos = NFL.flex_pos
    end
    
    if flex_pos.nil?
      @diff = Difference.position(params[:id].upcase).week(NFL.current_week).all
    else
      @diff = Difference.position(flex_pos).week(NFL.current_week).all
    end

  end

end
