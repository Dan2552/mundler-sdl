require "mundler/dsl"
require "mundler/clean_environment"
require_relative "sdl/path"
require_relative "sdl/host/all"
require_relative "sdl/ios/freetype"
require_relative "sdl/ios/libpng"
require_relative "sdl/ios/sdl2"
require_relative "sdl/ios/sdl2_image"
require_relative "sdl/ios/sdl2_ttf"
require_relative "sdl/git"
require_relative "sdl/platform"
require_relative "sdl/log_wrap"

module Mundler
  module SDL
    module Extension
      def load_libraries
        super
        libraries = Dir.glob(File.join(__dir__, "libraries", "*.rb"))
        libraries.each do |library|
          instance_eval(File.read(library))
        end
      end
    end
  end
end

Mundler::DSL.class_exec do
  prepend Mundler::SDL::Extension
end
