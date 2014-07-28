module ApplicationHelper

  # Estimation of the time to read a post
  # Merci Em-AK
  def get_reading_time(post)
    words_per_minute = 170.0
    time = post.word_count / words_per_minute
    reading_time = "#{time.round} min"
    if time < 1
            reading_time = "< 1 min"
    elsif time >= 1 && time < 1.6
            reading_time = "1 min"
    end
    reading_time
  end

  # Date
  def get_date(post)
    post.created_at.strftime("%e %b.")
  end
end