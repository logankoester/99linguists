module NinetyNineLinguists
  class FreelancerEngine

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

    def translate(from, to, from_text, options={})
      "Translated text"
    end

    # Options[:from] or options[:to] expects a language name
    # or ISO code as a string. Return true/false
    def language_supported?(options={})
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

  end
end
