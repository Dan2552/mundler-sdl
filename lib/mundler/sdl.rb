require "mundler/dsl"
require "mundler/clean_environment"
require_relative "sdl/path"
require_relative "sdl/build"
require_relative "sdl/git"

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
