module Mundler
  module SDL
    module Path
      def self.clone_dir(platform, suffix = "")
        File.join(ENV["HOME"], ".mundler", "libraries", "sdl2#{suffix}", platform, "clone")
      end

      def self.build_dir(platform)
        File.join(ENV["HOME"], ".mundler", "libraries", "sdl2", platform, "build")
      end
    end
  end
end
