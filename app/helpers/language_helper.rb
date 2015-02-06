module LanguageHelper
  def serve_by_language(obj,locale)
    case locale
    when 'fr'
      obj.where(language: 'french').order(created_at: :desc) 
    when 'en'
      obj.where(language: 'english').order(created_at: :desc)
    else 
      obj.order(created_at: :desc)
    end
  end
end