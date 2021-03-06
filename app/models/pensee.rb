class Pensee < ActiveRecord::Base
  validates_uniqueness_of :text
  attr_accessible :text

  def self.create_pensees
    file = open('public/pensees.txt').read
    parsed_text = Readability::Document.new(file, tags: %w[div]).content
    clean_ary = parsed_text.gsub(/<div>/, '')
                           .gsub(/<\/div>/, '')
                           .split(/\n/)
                           .to_s
    Pensee.count == 0 ? Pensee.create(text: clean_ary) : Pensee.update(1, text: clean_ary)
  end
end
