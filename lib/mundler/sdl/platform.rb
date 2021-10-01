module Mundler
  module SDL
    module Platform
      SUPPORTED = [
        "host",
        "ios",
        "ios_simulator"
      ]

      def self.validate!(name)
        return if SUPPORTED.include?(name)
        $stderr.puts("\e[31mMundle failed.\n\nUnsupported platform `#{name}` for the `mundler-sdl` gem. Supported platforms: #{SUPPORTED.inspect}\e[0m")
        exit 1
      end
    end
  end
end
