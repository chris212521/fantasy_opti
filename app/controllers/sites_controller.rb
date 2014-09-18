class SitesController < ApplicationController

  def index
    FFNerd.api_key = "test"
    
    @outputs = NFL.update_week_projections
    
    @outputs = FFNerd.schedule
    
    @x = FFNerd.schedule.first.gameDate[0,4]

  end

end
