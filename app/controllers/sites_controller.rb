class SitesController < ApplicationController
  def index  
    #NBA.bbr_p_gl_api('Durant','Kevin')
  end
  
  def admin

  end
  
  def update
    Util.update_NFL_week_projections
  end
end
