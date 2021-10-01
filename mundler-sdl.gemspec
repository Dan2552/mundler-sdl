Gem::Specification.new do |spec|
  root = File.expand_path('..', __FILE__)
  require File.join(root, "lib", "mundler", "sdl", "version.rb").to_s
  require "pathname"

  spec.name          = "mundler-sdl"
  spec.version       = Mundler::SDL::VERSION
  spec.authors       = ["Daniel Inkpen"]
  spec.email         = ["dan2552@gmail.com"]

  spec.summary       = %q{An extension to the mundler gem to add support for SDL2}
  spec.description   = %q{An extension to the mundler gem to add support for SDL2}
  spec.homepage      = "https://github.com/Dan2552/mundler-sdl"
  spec.license       = "MIT"

  spec.files = Dir
    .glob(File.join(root, "**", "*.rb"))
    .reject { |f| f.match(%r{^(test|spec|features)/}) }
    .map { |f| Pathname.new(f).relative_path_from(root).to_s }

  spec.files << "lib/mundler/cached_git/cached_git"
  spec.files << "lib/mundler/cached_git/git"

  if File.directory?(File.join(root, "exe"))
    spec.bindir = "exe"
    spec.executables = Dir.glob(File.join(root, "exe", "*"))
      .map { |f| File.basename(f) }
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "mundler", ">= 0.8.0"
end
