module Mundler
  module SDL
    def self.log_wrap(*args)
      if args.count == 1
        env = {}
        command = args.first
      elsif args.count == 2
        env = args[0]
        command = args[1]
      else
        raise "nope"
      end
      logfile = Tempfile.new(['mundler_build', '.log'])
      covered = 0
      output_thread = Thread.new do
        loop do
          count = File.read(logfile).split("\n").count
          diff = count - covered
          diff.times { print "\e[34m.\e[0m" }
          covered = count
          sleep(0.3)
        end
      end

      ::Mundler.with_clean_env do
        system(env, "(#{command}) >#{logfile.path} 2>&1") || begin
          output_thread.kill
          $stderr.print "\e[31mF\e[0m"
          $stderr.puts "\n\n"
          $stderr.puts File.read(logfile)

          return false
        end
      end

      puts ""
      return true
    ensure
      logfile.close if logfile
      output_thread.kill if output_thread
    end
  end
end
