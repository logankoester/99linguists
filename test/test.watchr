ENV["WATCHR"] = "1"
system 'clear'
puts "Watchr: Ready! :-)"

def notify_send(result)
  #title = "Watchr Test Results"
  title = result.split("\n")[-2] rescue nil
  message = result.split("\n")[-3] rescue nil
  unless message == nil or title == nil
    image = title.include?('0 failures, 0 errors') ? "~/.autotest_images/pass.png" : "~/.autotest_images/fail.png"
    options = "-c Watchr --icon '#{File.expand_path(image)}' '#{title}' '#{message}' --urgency=critical"
    system %(notify-send #{options} &)
  end
  #File.open('/tmp/testnotify.log','w+') { |f| f << %(notify-send #{options} &) }
end

def run(cmd)
  puts(cmd)
  `#{cmd}`
end

def run_test_file(file)
  system('clear')
  result = run(%Q(ruby -I"lib:test" -rubygems #{file}))
  notify_send result
  puts result
end

def run_all_tests
  system('clear')
  result = run "rake test"
  notify_send result
  puts result
end

def related_test_files(path)
  Dir['test/**/*.rb'].select { |file| file =~ /test_#{File.basename(path).split(".").first}.rb/ }
end

def run_suite
  run_all_tests
end

watch('test/helper\.rb') { run_all_tests }
watch('test/factories\.rb') { run_all_tests }
watch('test/.*test_.*\.rb') { |m| run_test_file(m[0]) }
watch('lib/.*\.rb') { |m| related_test_files(m[0]).map {|tf| run_test_file(tf) } }

# Ctrl-\
Signal.trap 'QUIT' do
  puts " --- Running all tests ---\n\n"
  run_all_tests
end

@interrupted = false

# Ctrl-C
Signal.trap 'INT' do
  if @interrupted then
    @wants_to_quit = true
    abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 1.5
    # raise Interrupt, nil # let the run loop catch it
    run_suite
  end
end
