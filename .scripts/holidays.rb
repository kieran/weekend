require 'rubygems'
require 'holidays'
require 'json'

def holidays(year=Time.now.year, locale='ca_on')

  # collect holidays
  stats     = Holidays.year_holidays([locale], Date.civil(year, 1, 1))
  informals = Holidays.year_holidays([locale, :informal], Date.civil(year, 1, 1))
  observed  = Holidays.year_holidays([locale, :observed], Date.civil(year, 1, 1))

  ret = []
  ret = ret + stats

  # mark informals
  informals_only = informals - stats
  ret = ret + informals_only.map{|h| h[:informal] = true; h }

  # mark observeds
  observed_only = observed - stats
  ret = ret + observed_only.map{|h| h[:observed] = true; h }

  # sort by date
  ret.sort{ |a,b| a[:date] <=> b[:date] }

end

Holidays.available_regions.select{|r|r.to_s.match /(ca|us|gb).*/}.each do |locale|
  out = holidays(Time.now.year, locale).to_json
  File.open("dist/#{locale}.json", 'w') { |file| file.write(out) }
end

# puts holidays.to_json; nil
