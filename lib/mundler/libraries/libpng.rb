module Mundler
  module SDL
    class LibpngLibrary
      def build(platform, options)
        # Skip for host, can just use OS installed libpng for now
        return if platform == "host"

        Platform.validate!(platform)

        ::Mundler::SDL::Git.clone(
          "https://github.com/glennrp/libpng",
          ::Mundler::SDL::Path.clone_dir(platform, "libpng")
        )

        simulator = platform == "ios_simulator"

        IOS::Libpng.compile(
          ::Mundler::SDL::Path.clone_dir(platform, "libpng"),
          ::Mundler::SDL::Path.build_dir(platform, "libpng"),
          simulator: simulator
        )
      end

      def platform_configuration(platform, options)
        return {} if platform == "host"

        path = ::Mundler::SDL::Path.build_dir(platform, "libpng")

        {
          cc: { flags: "-I#{path}/include/libpng" },
          linker: { flags: "-L#{path}/lib -lpng" }
        }
      end
    end
  end
end

define_library "libpng", Mundler::SDL::LibpngLibrary
