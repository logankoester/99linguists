module Google
  class Translator
    # Check if a language is supported.
    # Valid options are :from *OR* :to, with either the name or code of the language (case-insensitive)
    # Example #1: language_supported? :from => 'English' # => true
    # Example #2: language_supported? :to   => 'ru'      # => true
    def language_supported?(options={})
      supported = if options[:from]
        language = options[:from]
        supported_languages[:from_languages]
      elsif options[:to]
        language = options[:to]
        supported_languages[:to_languages]
      else
        raise "Options must include :from or :to"
      end
      supported.map! { |l| [l.code.downcase, l.name.downcase] }.flatten.include?(language.downcase)
    end
  end
end
