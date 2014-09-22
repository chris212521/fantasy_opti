class SitesController < ApplicationController
  def index  
    @x = Ranking.position(['RB','WR']).week(3).top_ppd_std
  end
end
