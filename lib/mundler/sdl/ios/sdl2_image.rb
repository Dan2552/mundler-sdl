module Mundler
  module SDL
    module IOS
      module SDL2Image
        def self.compile(clone_directory, output_build_dir, simulator: false)
          FileUtils.cd(clone_directory)

          if simulator
            success_indicator = File.join(Dir.pwd, ".mundler_compiled_simulator_successfully")
          else
            success_indicator = File.join(Dir.pwd, ".mundler_compiled_successfully")
          end

          return if File.file?(success_indicator)

          FileUtils.cd(File.join(clone_directory, "Xcode-iOS"))
          FileUtils.remove_dir(File.join(Dir.pwd, "build")) if File.directory?(File.join(Dir.pwd, "build"))

          configuration = "Release"

          clean_simulator = %W(
            xcodebuild
              -project SDL_image.xcodeproj
              -target libSDL_image-iOS
              -sdk iphonesimulator
              -arch arm64
              -arch x86_64
              -arch i386
              -configuration #{configuration}
              clean
          )

          clean_device = %W(
            xcodebuild
              -project SDL_image.xcodeproj
              -target libSDL_image-iOS
              -sdk iphoneos
              -arch arm64
              -arch armv7
              -arch armv7s
              -configuration #{configuration}
              clean
          )

          build_simulator = %W(
            xcodebuild
              -project SDL_image.xcodeproj
              -target libSDL_image-iOS
              -sdk iphonesimulator
              -arch arm64
              -arch x86_64
              -arch i386
              -configuration #{configuration}
              build
          )

          build_device = %W(
            xcodebuild
              -project SDL_image.xcodeproj
              -target libSDL_image-iOS
              -sdk iphoneos
              -arch arm64
              -arch armv7
              -arch armv7s
              -configuration #{configuration}
              build
          )

          if simulator
            command = [
              clean_simulator.join(" "),
              build_simulator.join(" "),
            ].join(" && ")
            build = File.join("build", "#{configuration}-iphonesimulator", "libSDL2_image.a")
          else
            command = [
              clean_device.join(" "),
              build_device.join(" ")
            ].join(" && ")
            build = File.join("build", "#{configuration}-iphoneos", "libSDL2_image.a")
          end

          ::Mundler::SDL.log_wrap(command) || begin
            FileUtils.remove_dir(output_build_dir) if File.directory?(output_build_dir)
            raise(Mundler::CompilationError)
          end

          FileUtils.mkdir_p(File.join(output_build_dir, "sdl_image", "include"))
          FileUtils.mkdir_p(File.join(output_build_dir, "sdl_image", "lib"))

          Dir.glob(File.join(clone_directory, "*.h")).each do |sdl_image_header|
            FileUtils.cp(sdl_image_header, File.join(output_build_dir, "sdl_image", "include"))
          end

          FileUtils.cp(build, File.join(output_build_dir, "sdl_image", "lib"))

          FileUtils.touch(success_indicator)
        end
      end
    end
  end
end
