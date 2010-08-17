module NinetyNineLinguists
  class GoogleEngine
    def initialize
      @google = Google::Translator.new
    end

    def translate(from, to, text, options={})
      @from, @to, @text = language_to_iso(from), language_to_iso(to), text
      set_defaults!
      return false unless both_languages_supported?
      @google.translate(@from, @to, @text, options)
    end

    # Options[:from] or options[:to] expects a language name
    # or ISO code as a string. Return true/false
    def language_supported?(options={})
      @google.language_supported?(options)
    end
    
  private
    # Looks up a language name or code, returning the code or false if not found
    def language_to_iso(language)
      language = language.to_s.downcase
      list = (@google.supported_languages[:from_languages] + @google.supported_languages[:to_languages]).uniq!
      match = list.find { |item| item.name.downcase == language or item.code.downcase == language }
      match ? match.code : false
    end

    def both_languages_supported?
      raise StandardError, "Unsupported language: #{@from}" unless language_supported?(:from => @from.to_s)
      raise StandardError, "Unsupported language: #{@to}"   unless language_supported?(:to   => @to.to_s)
      true
    end

    def set_defaults!
      @from ||= Translator.detect_language(@text)
    end

  end
end
