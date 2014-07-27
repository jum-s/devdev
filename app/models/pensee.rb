class Pensee < ActiveRecord::Base
  validates_uniqueness_of :text
  attr_accessible :text  
end
