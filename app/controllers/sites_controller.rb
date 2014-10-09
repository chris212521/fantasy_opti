class SitesController < ApplicationController
  def index  
    #NBA.bbr_p_adv_api('Durant','Kevin')
  end
  
  def admin

  end
  
  def update
    NFL.update_week_projections
  end
end
