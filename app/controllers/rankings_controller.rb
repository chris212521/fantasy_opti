class RankingsController < ApplicationController
  def qb_rankings
    @x = Ranking.position(['QB']).week(FFNerd.current_week).top_ppd_std
  end
  
  def current_rankings
    @rankings = Ranking.position(params[:id].upcase).week(NFL.current_week).top_ppd_std
  end
  
  def optimal_lineup
    @players = Ranking.week(NFL.current_week)
    optimized = NFL.optimal_ranking(Ranking.week(NFL.current_week))
    
    @lineup = optimized[0] 
    @salary_remaining = optimized[1]
  end
end
