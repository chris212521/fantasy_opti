class SitesController < ApplicationController
  def index  
    
  end
  
  def update
    NFL.update_week_projections
    
    query = "SELECT update_ppd(" + NFL.current_week.to_s + "," + NFL.current_year.to_s + ")"
    puts query
    ActiveRecord::Base.connection.execute(query)
  end
end
