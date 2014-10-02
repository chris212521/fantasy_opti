class SitesController < ApplicationController
  def index  
    
  end
  
  def admin

  end
  
  def update
    NFL.update_week_projections
  end
end
