desc "Get pensees.txt on github, parse, split and store in db"
task pensee: :environment do
  Pensee.new.create_pensees
end