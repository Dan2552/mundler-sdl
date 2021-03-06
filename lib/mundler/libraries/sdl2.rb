module Mundler
  module SDL
    class SDL2Library
      def build(platform, options)
        ::Mundler::SDL::Git.clone(
          "https://github.com/libsdl-org/SDL",
          ::Mundler::SDL::Path.clone_dir(platform)
        )

        ::Mundler::SDL::Build.compile(
          ::Mundler::SDL::Path.clone_dir(platform),
          ::Mundler::SDL::Path.build_dir(platform)
        )
      end

      def platform_configuration(platform, options)
        path = ::Mundler::SDL::Path.build_dir(platform)

        case platform.to_s
        when "host"
          {
            cc: { flags: "-I#{path}/include/SDL2" },
            linker: { flags: "-L#{path}/lib -lSDL2" } # TODO: -lSDL2_image -lSDL2_ttf
          }
        else
          raise "SDL2 support for #{platform} is unsupported"
        end
      end
    end
  end
end

define_library "sdl2", Mundler::SDL::SDL2Library
