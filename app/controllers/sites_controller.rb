class SitesController < ApplicationController
  def index  
    #@logs = Admin.scrape_NBA_daily_games(3,16)
    puts 'nope'
  end
  
  def nfl_update  
    Admin.update_NFL_week_projections
  end
  
  def admin

  end
  
  def scrape_nba_daily
    Admin.scrape_NBA_daily_games(params[:month],params[:day],params[:year])
  end
end
