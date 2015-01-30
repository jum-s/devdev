require 'active_support/concern'

module Scopes
  extend ActiveSupport::Concern
  
  included  do
    scope :has_video, ->  { where('url like ?', '%youtu%' || '%vimeo%' || '%dailymo%').order(created_at: :desc) }
    scope :has_title, ->  { where.not(title: nil).order(created_at: :desc) }
  end
end