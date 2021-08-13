module Mundler
  module SDL
    module Build
      def self.compile(clone_directory, output_build_dir)
        FileUtils.cd(clone_directory)

        success_indicator = File.join(Dir.pwd, ".mundler_compiled_successfully")
        return if File.file?(success_indicator)

        sdl_install = output_build_dir

        FileUtils.mkdir_p(sdl_install)

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
          system("./configure --prefix=#{sdl_install} >#{logfile.path} 2>&1 && make -j4 >#{logfile.path} 2>&1 && make install >#{logfile.path} 2>&1") || begin
            FileUtils.remove_dir(sdl_install) if File.directory?(sdl_install)
            $stderr.print "\e[31mF\e[0m"
            $stderr.puts "\n\n"
            $stderr.puts File.read(logfile)

            raise Mundler::CompilationError
          end
        end

        puts ""

        FileUtils.touch(success_indicator)
      ensure
        output_thread.kill if output_thread
      end
    end
  end
end
