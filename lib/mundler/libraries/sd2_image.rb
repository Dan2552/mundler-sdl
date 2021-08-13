module Mundler
  module SDL
    class SDL2ImageLibrary
      def build(platform, options)
        ::Mundler::SDL::Git.clone(
          "https://github.com/libsdl-org/SDL_image",
          ::Mundler::SDL::Path.clone_dir(platform, "image")
        )

        ::Mundler::SDL::Build.compile(
          ::Mundler::SDL::Path.clone_dir(platform, "image"),
          ::Mundler::SDL::Path.build_dir(platform)
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
        else
          raise "SDL2 image support for #{platform} is unsupported"
        end
      end
    end
  end
end

define_library "sdl2_image", Mundler::SDL::SDL2ImageLibrary
