require 'helper'

class Test99linguists < Test::Unit::TestCase
  include NinetyNineLinguists
  context "Using String#translate, " do
    context "(assuming valid languages)" do
      context "via options hash" do
        should "return the translated string with only :to" do
          assert_equal "Hello", "Bonjour".translate(:to => :english)
        end

        should "return the translated string with :to and :from" do
          assert_equal "Hello", "Bonjour".translate(:to => :english, :from => :french)
        end

        should "allow a custom engine" do
          assert_equal "Translated text", "Anything".translate(
            :to   => :english, 
            :from => :french,
            :with => ExampleEngine.new
          )
        end
      end

      context "via method chaining" do
        should "return the translated string after calling #to" do
          assert_equal "Hello", "Bonjour".translate.to(:english)
        end

        should "return the translated string with #to and #from" do
          assert_equal "Hello", "Bonjour".translate.from(:french).to(:english)
        end

        should "allow an engine to be specified" do
          result = "Anything".translate.with(ExampleEngine.new).from(:french).to(:english)
          assert_equal "Translated text", result
        end
      end
    end
  end

  context "A new Translator object" do
    context "(assuming valid languages)" do
      setup do
        @translator = Translator.new
      end

      should "use the GoogleEngine by default" do
        assert_kind_of GoogleEngine, @translator.engine
      end

      should "not be lazy by default" do
        assert !@translator.lazy
      end

      should "allow an engine to be specified with #with" do
        @translator.with ExampleEngine.new
        assert_kind_of ExampleEngine, @translator.engine
      end

      context "with laziness disabled" do
        should "never become 'ready'" do
          @translator.text("Bonjour")
          @translator.to :german
          assert !@translator.ready?
        end
      end

      context "with laziness enabled" do
        setup do
          @lazy_translator = Translator.new(:lazy => true)
        end
        should "translate as soon as ready" do
          @lazy_translator.text 'Hello'
          assert_equal 'Bonjour', @lazy_translator.to(:french)
        end
      end

      should "allow options to be set with the options hash" do
        hello = Translator.new(
          :text => "Hello", 
          :from => :english, 
          :to   => :french,
          :with => ExampleEngine.new
        )
        assert_equal "Translated text", hello.translate
      end

    end
  end

end
