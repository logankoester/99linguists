require 'google_translate'
require File.join(File.dirname(__FILE__), 'google_translate-language_supported') unless Google::Translator.respond_to?(:language_supported)
Dir["#{File.dirname(__FILE__)}/engines/**/*.rb"].each { |f| load(f) }

module NinetyNineLinguists
  class Translator
    def initialize(options={})
      @text, @from, @to, @lazy = options[:text], options[:from], options[:to], options[:lazy]
      @projectname, @projectdesc = options[:projectname], [:projectdesc]
      @engine = options[:with] or options[:engine]
    end

    def from(language)
      @from = language
      ready? ? translate : self
    end

    def to(language)
      @to = language
      ready? ? translate : self
    end

    def lazy(toggle = nil)
      return @lazy if toggle.nil?
      @lazy = toggle
    end

    def text(new_text = nil)
      return @text if new_text.nil?
      @text = new_text
    end

    def with(engine)
      @engine = engine
      ready? ? translate : self
    end

    def translate(new_text = nil)
      text(new_text)
      engine.translate(@from, @to, @text)
    end

    def self.detect_language(text)
      Google::Translator.new.detect_language(text)['language']
    end

    def ready?
      @text and @to and @lazy
    end

    def engine
      @engine ||= GoogleEngine.new
    end
  end
end

class String
  include NinetyNineLinguists
  def translate(options={})
    options.merge!({:lazy => true, :text => self})
    translator = Translator.new(options)
    translator.ready? ? translator.translate : translator
  end

  def language?
    Translator.detect_language(self)
  end
end
