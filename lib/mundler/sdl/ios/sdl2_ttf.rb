module Mundler
  module SDL
    module IOS
      module SDL2TTF
        def self.compile(clone_directory, output_build_dir, simulator: false)
          FileUtils.cd(clone_directory)

          if simulator
            success_indicator = File.join(Dir.pwd, ".mundler_compiled_simulator_successfully")
          else
            success_indicator = File.join(Dir.pwd, ".mundler_compiled_successfully")
          end

          return if File.file?(success_indicator)

          FileUtils.cd(File.join(clone_directory, "Xcode"))
          FileUtils.remove_dir(File.join(Dir.pwd, "build")) if File.directory?(File.join(Dir.pwd, "build"))

          configuration = "Release"

          clean_simulator = <<-STR
            xcodebuild \
              -project SDL_ttf.xcodeproj \
              -target "Static Library-iOS" \
              -sdk iphonesimulator \
              -configuration #{configuration} \
              clean
          STR

          clean_device = <<-STR
            xcodebuild \
              -project SDL_ttf.xcodeproj \
              -target "Static Library-iOS" \
              -sdk iphoneos \
              -configuration #{configuration} \
              clean
          STR

          build_simulator = <<-STR
            xcodebuild \
              -project SDL_ttf.xcodeproj \
              -target "Static Library-iOS" \
              -sdk iphonesimulator \
              -arch x86_64 \
              -arch i386 \
              -configuration #{configuration} \
              build
          STR

          build_device = <<-STR
            xcodebuild \
              -project SDL_ttf.xcodeproj \
              -target "Static Library-iOS" \
              -sdk iphoneos \
              -arch arm64 \
              -arch armv7 \
              -arch armv7s \
              -configuration #{configuration} \
              build
          STR

          if simulator
            command = [
              clean_simulator,
              build_simulator,
            ].join(" && ").gsub("\\\n", " ").gsub("\n", " ")
            build = File.join("build", "#{configuration}-iphonesimulator", "libSDL2_ttf.a")
          else
            command = [
              clean_device,
              build_device
            ].join(" && ").gsub("\\\n", " ").gsub("\n", " ")
            build = File.join("build", "#{configuration}-iphoneos", "libSDL2_ttf.a")
          end

          ::Mundler::SDL.log_wrap(command) || begin
            FileUtils.remove_dir(output_build_dir) if File.directory?(output_build_dir)
            raise(Mundler::CompilationError)
          end

          FileUtils.mkdir_p(File.join(output_build_dir, "sdl_ttf", "include"))
          FileUtils.mkdir_p(File.join(output_build_dir, "sdl_ttf", "lib"))

          Dir.glob(File.join(clone_directory, "*.h")).each do |sdl_image_header|
            FileUtils.cp(sdl_image_header, File.join(output_build_dir, "sdl_ttf", "include"))
          end

          FileUtils.cp(build, File.join(output_build_dir, "sdl_ttf", "lib"))

          FileUtils.touch(success_indicator)
        end
      end
    end
  end
end
