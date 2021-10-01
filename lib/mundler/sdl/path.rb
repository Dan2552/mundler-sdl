module Mundler
  module SDL
    module Path
      def self.clone_dir(platform, custom_name = nil)
        name = custom_name || "sdl"
        File.join(ENV["HOME"], ".mundler", "libraries", platform, "clone", name)
      end

      def self.build_dir(platform, custom_name = nil)
        name = custom_name || "sdl"
        File.join(ENV["HOME"], ".mundler", "libraries", platform, "build", name)
      end
    end
  end
end
