require 'rubygems'
require 'fileutils'
require 'holidays'
require 'json'

def holidays(year=Time.now.year, locale='ca_on')

  # collect holidays
  stats     = Holidays.year_holidays([locale], Date.civil(year, 1, 1))
  informals = Holidays.year_holidays([locale, :informal], Date.civil(year, 1, 1)) - stats
  observed  = Holidays.year_holidays([locale, :observed], Date.civil(year, 1, 1))

  ret = {}

  stats.each do |h|
    ret[h[:name]] = h
  end

  informals.each do |h|
    h[:informal] = true
    ret[h[:name]] = h
  end

  observed.each do |h|
    ret[h[:name]][:observed] = h[:date] unless ret[h[:name]][:date] == h[:date]
  end

  # sort by date
  ret.values.sort{ |a,b| a[:date] <=> b[:date] }

end

Holidays.available_regions.select{|r|r.to_s.match /^(ca|us|gb)_.*/}.each do |locale|
  out = holidays(Time.now.year, locale).map{|h|h.delete(:regions); h}.to_json
  FileUtils.mkdir_p('dist/holidays')
  File.open("dist/holidays/#{locale}.json", 'w') { |file| file.write(out) }
end
