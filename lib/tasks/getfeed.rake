desc "Get/retrieve feed infos from framabag, filter, and add to database if don't exist"

task getfeed: :environment do
  Autopost.add_new
end

