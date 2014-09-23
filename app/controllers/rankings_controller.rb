class RankingsController < ApplicationController
  def qb_rankings
    @x = Ranking.position(['QB']).week(FFNerd.current_week).top_ppd_std
  end
  
  def current_rankings
    FFNerd.api_key = "bm37zp5dfhjh"
    if params[:id].upcase == 'FLEX'
      flex_pos = NFL.flex_pos
    end
    
    if params[:id].upcase == 'K'
      @rankings = Projection.position('K').week(NFL.current_week).top_std_proj
    elsif flex_pos.nil?
      @rankings = Ranking.position(params[:id].upcase).week(NFL.current_week).top_ppd_std
    else
      @rankings = Ranking.position(flex_pos).week(NFL.current_week).top_ppd_std
    end
  end
  
  def optimal_lineup    
    @test = NFL.find_max_option(50000,Ranking.week(NFL.current_week).all)
  end
end
