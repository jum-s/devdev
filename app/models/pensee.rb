class Pensee < ActiveRecord::Base
  validates_uniqueness_of :text
  attr_accessible :text

  def create_pensees
    opened_doc = open('https://raw.githubusercontent.com/jum-s/notes/master/pensees.txt').read
    parsed_text = Readability::Document.new(opened_doc, :tags => %w[div]).content
    clean_ary = parsed_text.gsub(/<div>/, '')
                                          .gsub(/<\/div>/, '')
                                          .split(/\n/).to_s
    if Pensee.any? == false
      Pensee.create(text: clean_ary) 
    else
      Pensee.update(1, text: clean_ary)
    end
  end
end
