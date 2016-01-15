require 'rest-client'
require 'nokogiri'
require 'pry'

url = "https://en.wikipedia.org/wiki/List_of_Friends_episodes"
page = Nokogiri::HTML(RestClient.get(url))
seasons = page.css('h3 span[class=mw-headline]')

episodes_info = page.css('tr[class=vevent]')

seasons_summary = page.css('body table').first.css('tr')
episodes_per_season = {}

seasons_summary.drop(2).each do |row|
	season_number = row.css('td a').text.to_i
	number_of_episodes = row.css('td:nth-child(3)').text.to_i
	episodes_per_season[season_number] = number_of_episodes
end


def print_season_number(episodes_hash, seasons_hash, episode_number)
	running_total = 0
	episodes_hash.each do |k,v|
		running_total += v
		if episode_number == (running_total + 1)
			puts "= " * 15
			puts seasons_hash[k].text
			puts "= " * 15
		end
	end
end

puts seasons[0].text
puts "= " * 15
episodes_info.each do |episode|
	if (episode.css('th[id=epS01]').text == "S01") || (episode.css('th[id=epS02-S03]').text == "S02-S03")
		title = episode.css('td[class=summary]').text
		aired = episode.css('td')[1].children[0].text
		puts "- " * 15
		puts "Special Episode: #{title}, aired #{aired}."
		puts "- " * 15
	else
		print_season_number(episodes_per_season, seasons, episode.css('th').text.to_i)
		number = episode.css('td')[0].text
		title = episode.css('td[class=summary]').text
		aired = episode.css('td')[4].children[0].text
		puts "Episode #{number}: #{title}, aired #{aired}."
	end
end