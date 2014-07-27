desc "Get pensees.txt on github, parse, split and store in db"
task pensee: :environment do
  opened_doc = open("https://raw.githubusercontent.com/jum-s/notes/master/pens%C3%A9es.txt").read
  parsed_text = Readability::Document.new(opened_doc, :tags => %w[div]).content
  html_clean_text = parsed_text.gsub(/<div>/, '').gsub(/<\/div>/, '')
  textes_array_stringfied = html_clean_text.split(/\n/).to_s
  if Pensee.any? == false
    Pensee.create(text: textes_array_stringfied) 
  else
    Pensee.update(1, text: textes_array_stringfied)
  end
end