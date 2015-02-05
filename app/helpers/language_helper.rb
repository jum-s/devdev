module LanguageHelper
  def serve_by_language(obj,locale)
    case locale
    when 'fr'
      obj.where(language: 'french') 
    when 'en'
      obj.where(language: 'english')
    else 
      obj
    end
  end
end