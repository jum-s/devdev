desc "Get/retrieve feed infos from framabag, filter, and add to database if don't exist"

task getfeed: :environment do
  autopost = Autopost.new
  autopost.framabag_filter
end

