module Mundler
  module SDL
    class SDL2Library
      def build(platform)
        original_dir = Dir.pwd
        FileUtils.mkdir_p(build_dir(platform))
        FileUtils.cd(build_dir(platform))

        Mundler.with_clean_env do
          git_clone
          FileUtils.cd(File.join(build_dir(platform), "clone"))
          compile
        end

        FileUtils.cd(original_dir)
      end

      def platform_configuration(platform, options)
        path = options[:path]

        raise "Expected :path option for SDL2" unless path

        case platform.to_s
        when "host"
          {
            cc: { flags: "-I#{path}/include/SDL2" },
            linker: { flags: "-L#{path}/lib -lSDL2 -lSDL2_image -lSDL2_ttf" }
          }
        else
          raise "SDL2 support for #{platform} is unsupported"
        end
      end

      private

      def git_clone
        success_indicator = File.join(Dir.pwd, ".mundler_cloned_successfully")
        return if File.file?(success_indicator)

        system(
          {
            # The {mundler gem path}/cached_git directory contains a binary called
            # `git` that will run instead of normal git, making a cache of a
            # clone.
            "PATH" => ([cached_git_dir] + ENV["PATH"].split(":")).join(":")
          },
          "git clone https://github.com/libsdl-org/SDL clone >/dev/null 2>&1"
        ) || error_out("Failed to clone mruby: #{mruby_url}")

        FileUtils.touch(success_indicator)
      end

      def compile
        success_indicator = File.join(Dir.pwd, ".mundler_compiled_successfully")
        return if File.file?(success_indicator)

        sdl_install = File.expand_path(File.join(Dir.pwd, "..", "install"))

        FileUtils.remove_dir(sdl_install) if File.directory?(sdl_install)
        FileUtils.mkdir_p(sdl_install)

        system("./configure --prefix=#{sdl_install} && make -j4 && make install") || begin
          error("Failed to compile SDL2")
        end

        FileUtils.touch(success_indicator)
      end

      def build_dir(platform)
        File.join(ENV["HOME"], ".mundler", "libraries", "sdl2", platform)
      end

      def cached_git_dir
        dir = File.expand_path(File.join(__dir__, "..", "cached_git"))
        raise "cached git not found" unless File.file?(File.join(dir, "git"))
        raise "cached git not found" unless File.file?(File.join(dir, "cached_git"))
        dir
      end
    end
  end
end

define_library "sdl2", Mundler::SDL::SDL2Library
