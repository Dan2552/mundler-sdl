module Mundler
  module SDL
    class SDL2TTFLibrary
      def build(platform, options)
        ::Mundler::SDL::Git.clone(
          "https://github.com/libsdl-org/SDL_ttf",
          ::Mundler::SDL::Path.clone_dir(platform, "ttf")
        )

        ::Mundler::SDL::Build.compile(
          ::Mundler::SDL::Path.clone_dir(platform, "ttf"),
          ::Mundler::SDL::Path.build_dir(platform)
        )
      end

      def platform_configuration(platform, options)
        path = ::Mundler::SDL::Path.build_dir(platform)

        case platform.to_s
        when "host"
          {
            cc: { flags: "-I#{path}/include/SDL2" },
            linker: { flags: "-L#{path}/lib -lSDL2_ttf" }
          }
        else
          raise "SDL2 TTF support for #{platform} is unsupported"
        end
      end
    end
  end
end

define_library "sdl2_ttf", Mundler::SDL::SDL2TTFLibrary
