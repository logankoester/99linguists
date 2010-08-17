require 'google_translate'
require File.join(File.dirname(__FILE__), 'google_translate-language_supported') unless Google::Translator.respond_to?(:language_supported)

class Translator

  DEFAULT_DESCRIPTION = <<-eos
I am looking for a fluent speaker of both languages to translate a document. I will not be available to answer
questions, so please ensure that you fully understand my requirements before bidding.

I will award the project to the offer with the highest rating within my stated budget. No other criteria will be
considered. Full payment will be placed into escrow when you have been awarded the project.

The original formatting of the document (if any) should be preserved.

If you cannot complete the job within the stated timeframe, the project will be cancelled.

When you are finished, simply attach the translated document in same format as the original to the project message
board. I will then release the escrowed funds.

A native speaker will quickly review its quality and rate your work.

Thanks and good luck!
  eos

  attr_reader :from, :to
  attr_accessor :text, :engine, :projectname
  attr_writer :lazy

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

  def lazy(toggle)
    @lazy = toggle
  end

  # Alias for syntactic sugar
  def with=(engine)
    @engine = engine
  end

  def with(engine)
    @engine = engine
    ready? ? translate : self
  end

  def translate(text = nil)
    @text     = text if text
    set_defaults!

    if engine.is_a? Freelancer::Client
      project.projectname @projectname
      project.projectdesc @projectdesc
    elsif engine.is_a? Google::Translator
      return false unless both_languages_supported?
      engine.translate(
        language_code(@from), 
        language_code(@to), 
        @text
      )
    else
      raise StandardError, "Unspecified translation engine"
    end
  end

  def project
    return nil unless engine.is_a? Freelancer::Client
    @project ||= engine.account.employer.post_new_project
  end

  def projectname(name = nil)
    if name
      @projectname = name
    else
      from = @from ? " from #{@from} " : ' '
      "Translate ~#{word_count}-word textfile#{from}into #{@to}"
    end
  end

  def projectdesc(description)
    @projectdesc = description
  end

  def self.detect_language(text)
    Google::Translator.new.detect_language(text)['language']
  end

  # Looks up a language name or code, returning the code or false if not found
  def language_code(language)
    language = language.to_s.downcase
    list = (engine.supported_languages[:from_languages] + engine.supported_languages[:to_languages]).uniq!
    match = list.find { |item| item.name.downcase == language or item.code.downcase == language }
    match ? match.code : false
  end

  def ready?
    @text and @to and @lazy
  end
private

  def engine
    @engine ||= Google::Translator.new
  end

  def word_count
    @text.split(' ').size
  end

  def both_languages_supported?
    raise StandardError, "Unsupported language: #{@from}" unless engine.language_supported?(:from => @from.to_s)
    raise StandardError, "Unsupported language: #{@to}"   unless engine.language_supported?(:to   => @to.to_s)
    true
  end

  def set_defaults!
    @from ||= Translator.detect_language(@text)
    if engine.is_a? Freelancer::Client
      projectname @projectname
      projectdesc DEFAULT_DESCRIPTION
    end
  end

end

class String
  def translate(options={})
    options.merge!({:lazy => true, :text => self})
    translator = Translator.new(options)
    translator.translate if translator.ready?
  end

  def language?
    Translator.detect_language(self)
  end
end
