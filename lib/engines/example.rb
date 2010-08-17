# If you want to add an engine, it should look like this:

module NinetyNineLinguists
  class ExampleEngine
    def translate(from, to, from_text, options={})
      "Translated text"
    end

    # Options[:from] or options[:to] expects a language name
    # or ISO code as a string. Return true/false
    def language_supported?(options={})
    end
  end
end
