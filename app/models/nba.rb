class NBA
  
  def self.bbr_scrape_for_objects(last_name, first_name, url)
    #set BBR params for kimonolabs API
    kimpath2 = '&kimpath2='+last_name[0]
    kimpath3 = '&kimpath3='+last_name[0,5]+first_name[0,2]+'01'
  
    #get the JSON data from KimonoLabs
    json = RestClient.get url+kimpath2+kimpath3
    #turn the results into openstruct
    results = JSON[json]['results']['collection1'].collect! { |i| OpenStruct.new(i) }
  end
  
  #basketball reference player gamelog API
  def self.bbr_p_gl_api(last_name, first_name)    

    @results = bbr_scrape_for_objects(last_name, first_name, 'https://www.kimonolabs.com/api/azhla1b0?apikey=771398b183d34e1ede4772328e8c311c')
    
    @results.each do |r|
      puts r.fga
    end

  end
  
  def self.bbr_p_adv_api(last_name, first_name)

    @results = bbr_scrape_for_objects(last_name, first_name, 'https://www.kimonolabs.com/api/5u0knvjw?apikey=771398b183d34e1ede4772328e8c311c')
    
    @results.each do |r|
      puts r.ts_pct
    end
    
  end

end