module Mundler
  module SDL
    class FreetypeLibrary
      def build(platform, options)
        # Skip for host, can just use OS installed freetype for now
        return if platform == "host"

        Platform.validate!(platform)

        ::Mundler::SDL::Git.clone(
          "https://github.com/freetype/freetype",
          ::Mundler::SDL::Path.clone_dir(platform, "freetype")
        )

        simulator = platform == "ios_simulator"

        IOS::Freetype.compile(
          ::Mundler::SDL::Path.clone_dir(platform, "freetype"),
          ::Mundler::SDL::Path.build_dir(platform, "freetype"),
          simulator: simulator
        )
      end

      def platform_configuration(platform, options)
        return {} if platform == "host"

        path = ::Mundler::SDL::Path.build_dir(platform, "freetype")

        {
          cc: { flags: "-I#{path}/include/freetype" },
          linker: { flags: "-L#{path}/lib -lFreetype" }
        }
      end
    end
  end
end

define_library "freetype", Mundler::SDL::FreetypeLibrary
