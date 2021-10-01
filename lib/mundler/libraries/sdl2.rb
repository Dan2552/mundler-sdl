module Mundler
  module SDL
    class SDL2Library
      def build(platform, options)
        Platform.validate!(platform)

        ::Mundler::SDL::Git.clone(
          "https://github.com/libsdl-org/SDL",
          ::Mundler::SDL::Path.clone_dir(platform)
        )

        simulator = platform == "ios_simulator"

        builder(platform).compile(
          ::Mundler::SDL::Path.clone_dir(platform),
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
            linker: { flags: "-L#{path}/lib -lSDL2" }
          }
        when "ios", "ios_simulator"
          {
            cc: { flags: "-I#{path}/sdl/include" },
            linker: { flags: "-L#{path}/sdl/lib -lSDL2 -framework AudioToolbox -framework AVFoundation -framework CoreBluetooth -framework CoreGraphics -framework CoreMotion -framework CoreServices -framework Foundation -framework GameController -framework ImageIO -framework Metal -framework OpenGLES -framework QuartzCore -framework UIKit -framework CoreHaptics -lc++ -lz -lbz2" }
          }
        end
      end

      private

      def builder(platform)
        case platform
        when "host"
          Host::All
        when "ios"
          IOS::SDL2
        when "ios_simulator"
          IOS::SDL2
        end
      end
    end
  end
end

define_library "sdl2", Mundler::SDL::SDL2Library
