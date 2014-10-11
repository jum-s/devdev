module ApplicationHelper
  # Estimation of the time to read a post, Merci Em-AK !
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

  def get_date(post)
    post.created_at.strftime("%e %b.")
  end

  def get_language(post)
    case post.language 
      when "english" then " | #{image_tag 'uk.png', size: '20x20'}".html_safe
      when "french" then " | #{image_tag 'fr.png', size: '20x20'}".html_safe
      else
    end
  end

  def get_sentiment(post)
    case post.sentiment 
      when 1 then " | #{icon('smile-o')}".html_safe
      when 2 then " | #{icon('meh-o')}".html_safe
      when 3 then " | #{icon('frown-o')}".html_safe
      else
    end
  end

  def has_video(post)
    video = true if post.url.include?("dailymo") || post.url.include?("youtu")
    video
  end
end