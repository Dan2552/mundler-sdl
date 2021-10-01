module Mundler
  module SDL
    module IOS
      module SDL2
        def self.compile(clone_directory, output_build_dir, options = {})
          FileUtils.cd(clone_directory)

          success_indicator = File.join(Dir.pwd, ".mundler_compiled_successfully")
          return if File.file?(success_indicator)

          ::Mundler::SDL.log_wrap("build-scripts/iosbuild.sh") || begin
            FileUtils.remove_dir(output_build_dir) if File.directory?(output_build_dir)
            raise(Mundler::CompilationError)
          end

          FileUtils.mkdir_p(File.join(output_build_dir, "sdl", "lib"))
          FileUtils.cp(File.join(clone_directory, "ios-build/lib/libSDL2.a"), File.join(output_build_dir, "sdl", "lib"))
          FileUtils.cp_r(File.join(clone_directory, "include"), File.join(output_build_dir, "sdl", "include"))
          FileUtils.touch(success_indicator)
        end
      end
    end
  end
end
