$last_mod = Time.now

watch(/.*\.[mh]$/) { |m|

  require 'colorize'

  # puts m

  if Time.now - $last_mod > 2
    $last_mod = Time.now

    #puts "running"

    results = `./run_tests`

    puts results

    if results =~ /FAILED/
      puts "##################### FAILED #########################".red
    else
      puts "#################### PASSED #########################".green
    end

  end

}
