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
  
  def self.injury_report_scraper

      url = 'https://www.kimonolabs.com/api/2zwalswa?apikey=771398b183d34e1ede4772328e8c311c'
      json = RestClient.get url
      results = JSON[json]['results']['collection1'].collect! { |i| OpenStruct.new(i) }
      
        results.each do |r|
          r.player_name = r.player_name["text"]
        end
      
      NBA_Injury_report.update_injury_report(results)
    
  end
  
  def self.team_ranking_scraper(team_codes)
    rankings = []
    arr = team_codes[1..-2].split(',').collect! {|n| n.to_s}
    arr.each do |team_code|
      html = 'http://www.basketball-reference.com/teams/'+team_code+'/2015.html'
      doc = Nokogiri::HTML(open(html))
      
      if team_code == 'NOP'
        team_code = 'NO' #modify to match how we store it elsewhere
      elsif team_code == 'CHO'
        team_code = 'CHA'
      elsif team_code == 'PHO'
        team_code = 'PHX'
      end

        vals = {}
        
          doc.xpath('//*[@id="all_team_stats"]//tbody//tr[2]').each_with_index do |row, i|
            cols = row.search('td/text()').map(&:to_s)
            if i == 0
              vals = {
              :team => team_code,
              :fgm  => cols[2],
              :fga => cols[3],
              :fg_pct => cols[4],
              :tpm => cols[5],
              :tpa => cols[6],
              :tp_pct => cols[7],
              :ftm => cols[11],
              :fta => cols[12],
              :ft_pct => cols[13],
              :orb => cols[14],
              :drb => cols[15],
              :trb => cols[16],
              :assists => cols[17],
              :steals => cols[18],
              :blocks => cols[19],
              :tov => cols[20],
              :pf => cols[21],
              :points => cols[22]
            }
            elsif i == 1
            vals.merge!( {
              :opp_fgm  => cols[2],
              :opp_fga => cols[3],
              :opp_fg_pct => cols[4],
              :opp_tpm => cols[5],
              :opp_tpa => cols[6],
              :opp_tp_pct => cols[7],
              :opp_ftm => cols[11],
              :opp_fta => cols[12],
              :opp_ft_pct => cols[13],
              :opp_orb => cols[14],
              :opp_drb => cols[15],
              :opp_trb => cols[16],
              :opp_assists => cols[17],
              :opp_steals => cols[18],
              :opp_blocks => cols[19],
              :opp_tov => cols[20],
              :opp_pf => cols[21],
              :opp_points => cols[22]
            })
            end
          end
          
          doc.xpath('//*[@id="all_team_stats"]//tbody//tr[3]').each_with_index do |row, i|
            cols = row.search('td/text()').map(&:to_s)
            if i == 0
              vals.merge!( {
              :fgm_rank  => cols[2],
              :fga_rank => cols[3],
              :fg_pct_rank => cols[4],
              :tpm_rank => cols[5],
              :tpa_rank => cols[6],
              :tp_pct_rank => cols[7],
              :ftm_rank => cols[11],
              :fta_rank => cols[12],
              :ft_pct_rank => cols[13],
              :orb_rank => cols[14],
              :drb_rank => cols[15],
              :trb_rank => cols[16],
              :assists_rank => cols[17],
              :steals_rank => cols[18],
              :blocks_rank => cols[19],
              :tov_rank => cols[20],
              :pf_rank => cols[21],
              :points_rank => cols[22]
            })
            elsif i == 1
            vals.merge!( {
              :opp_fgm_rank  => cols[2],
              :opp_fga_rank => cols[3],
              :opp_fg_pct_rank => cols[4],
              :opp_tpm_rank => cols[5],
              :opp_tpa_rank => cols[6],
              :opp_tp_pct_rank => cols[7],
              :opp_ftm_rank => cols[11],
              :opp_fta_rank => cols[12],
              :opp_ft_pct_rank => cols[13],
              :opp_orb_rank => cols[14],
              :opp_drb_rank => cols[15],
              :opp_trb_rank => cols[16],
              :opp_assists_rank => cols[17],
              :opp_steals_rank => cols[18],
              :opp_blocks_rank => cols[19],
              :opp_tov_rank => cols[20],
              :opp_pf_rank => cols[21],
              :opp_points_rank => cols[22]
            })
            end
          end
          
          puts vals
          rankings << vals
    end
    NBA_Team_Ranking.update_ranking(rankings)
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