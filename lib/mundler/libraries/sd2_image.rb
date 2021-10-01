module Mundler
  module SDL
    class SDL2ImageLibrary
      def build(platform, options)
        Platform.validate!(platform)

        ::Mundler::SDL::Git.clone(
          "https://github.com/libsdl-org/SDL_image",
          ::Mundler::SDL::Path.clone_dir(platform, "sdl_image")
        )

        simulator = platform == "ios_simulator"

        builder(platform).compile(
          ::Mundler::SDL::Path.clone_dir(platform, "sdl_image"),
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
            linker: { flags: "-L#{path}/lib -lSDL2_image" }
          }
        when "ios", "ios_simulator"
          {
            cc: { flags: "-I#{path}/sdl_image/include" },
            linker: { flags: "-L#{path}/sdl_image/lib -lSDL2_image" }
          }
        end
      end

      private

      def builder(platform)
        case platform
        when "host"
          Host::All
        when "ios"
          IOS::SDL2Image
        when "ios_simulator"
          IOS::SDL2Image
        end
      end
    end
  end
end

define_library "sdl2_image", Mundler::SDL::SDL2ImageLibrary
