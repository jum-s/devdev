module ApplicationHelper
 
  # Estimation of the time to read a post, Merci Em-AK !
  def display_reading_time(post)
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

  def display_language(post)
    case post.language 
      when "english" then " | #{image_tag 'uk.png', size: '20x20'}".html_safe
      when "french" then " | #{image_tag 'fr.png', size: '20x20'}".html_safe
      else
    end
  end

  def display_sentiment(post)
    case post.sentiment 
      when 1 then " | #{icon('smile-o')}".html_safe
      when 2 then " | #{icon('meh-o')}".html_safe
      when 3 then " | #{icon('frown-o')}".html_safe
      else
    end
  end

  def random_color
    color_array = [
      "rgba(232, 202, 179, 0.6)", 
      "rgba(225, 226, 117, 0.6)", 
      "rgba(255, 125, 132, 0.6)", 
      "rgba(190, 102, 232, 0.6)", 
      "rgba(112, 134, 255, 0.6)", 
      "rgba(247, 122, 82, 0.6)", 
      "rgba(255, 151, 79, 0.6)"]
    color_array.sample
  end
end
