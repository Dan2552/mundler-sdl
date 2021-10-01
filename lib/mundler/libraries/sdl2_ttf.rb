module Mundler
  module SDL
    class SDL2TTFLibrary
      def build(platform, options)
        Platform.validate!(platform)

        ::Mundler::SDL::Git.clone(
          "https://github.com/libsdl-org/SDL_ttf",
          ::Mundler::SDL::Path.clone_dir(platform, "sdl_ttf")
        )

        simulator = platform == "ios_simulator"

        builder(platform).compile(
          ::Mundler::SDL::Path.clone_dir(platform, "sdl_ttf"),
          ::Mundler::SDL::Path.build_dir(platform),
          simulator: simulator
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
        when "ios", "ios_simulator"
          {
            cc: { flags: "-I#{path}/sdl_ttf/include" },
            linker: { flags: "-L#{path}/sdl_ttf/lib -lSDL2_ttf" }
          }
        end
      end

      private

      def builder(platform)
        case platform
        when "host"
          Host::All
        when "ios"
          IOS::SDL2TTF
        when "ios_simulator"
          IOS::SDL2TTF
        end
      end
    end
  end
end

define_library "sdl2_ttf", Mundler::SDL::SDL2TTFLibrary
