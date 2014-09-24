class RankingsController < ApplicationController
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
    if(params.has_key?(:salary) and params.has_key?(:position1))
      start = Time.new
      pos = []
      pos << params[:position1]
      pos << params[:position2]
      pos << params[:position3]
      pos << params[:position4]
      pos << params[:position5]
      pos.reject!(&:nil?)
  
      @lineup = NFL.find_max_option(params[:salary].to_i, pos)
      stop = Time.new
      @timer = stop-start
        puts "Time elapsed in Controller: #{stop - start} seconds"
    end
  end

end
