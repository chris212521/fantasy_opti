class BBR
    def self.scrape_for_player_stats(last_name, first_name, url)
    #set BBR params for kimonolabs API
    kimpath2 = '&kimpath2='+last_name[0]
    kimpath3 = '&kimpath3='+last_name[0,5]+first_name[0,2]+'01'
  
    #get the JSON data from KimonoLabs
    json = RestClient.get url+kimpath2+kimpath3
    #turn the results into openstruct
    results = JSON[json]['results']['collection1'].collect! { |i| OpenStruct.new(i) }
  end
  
  def self.boxscore_scraper(game_ids, date=nil)
    
    game_ids.each do |gid|
      
      url = 'https://www.kimonolabs.com/api/eefuzgva?apikey=771398b183d34e1ede4772328e8c311c'+'&kimpath2='+gid #201403150ATL.html
      json = RestClient.get url
      results = JSON[json]['results']['collection1'].collect! { |i| OpenStruct.new(i) }
      results.reject! { |x| x.points.empty? }
      
        results.each do |r|
          r.player_name = r.player_name["text"]
          r.game_date = date
        end
      
      NBA_Game_Log.save_game_logs(results)
    end
    
  end
  
  def self.daily_boxscores_links(month, day, year=2014)
    url = 'https://www.kimonolabs.com/api/b549cn5q?apikey=771398b183d34e1ede4772328e8c311c'+'&month='+month.to_s+'&day='+day.to_s+'&year='+year.to_s

    json = RestClient.get url
    
    results = JSON[json]['results']['collection1'].collect! { |i| OpenStruct.new(i) }

    #don't know why the API grabs this game all the time...
    results.reject! { |x| x.boxscore_links["href"] == "http://www.basketball-reference.com/boxscores/201406150SAS.html" }
    
    game_ids = []
    
    results.each do |x|
      game_ids << x.boxscore_links["href"][/\d+\w+.html/]
    end
    
    boxscore_scraper(game_ids, year.to_s+'-'+month.to_s+'-'+day.to_s)
  end
  
  #basketball reference player gamelog API
  def self.download_player_gamelog(last_name, first_name, games=5)    

    @results = scrape_for_player_stats(last_name, first_name, 'https://www.kimonolabs.com/api/azhla1b0?apikey=771398b183d34e1ede4772328e8c311c').last(games)

    @results.each do |x|
      x.player_name = first_name+' '+last_name
      x.team_name = x.team_name["text"]
      x.game_date = x.game_date["text"]
      x.opponent_team = x.opponent_team["text"]
    end
    
    NBA_Game_Log.save_game_logs(@results)
  end
  
  def self.player_advanced_stats(last_name, first_name)

    @results = scrape_for_player_stats(last_name, first_name, 'https://www.kimonolabs.com/api/5u0knvjw?apikey=771398b183d34e1ede4772328e8c311c')
    
    @results.each do |r|
      puts r.ts_pct
    end
    
  end

end