module Mundler
  module SDL
    module IOS
      module Libpng
        def self.compile(clone_directory, output_build_dir, simulator: false)
          FileUtils.cd(clone_directory)

          host = "aarch64-apple-darwin"
          minimum_ios_version = "10.0"

          if simulator
            arch = `uname -m`.chomp
            host = "x86_64-apple-darwin" if arch != "arm64"
            sdk = `xcrun --sdk iphonesimulator --show-sdk-path`.chomp
            success_indicator = File.join(Dir.pwd, ".mundler_compiled_simulator_successfully")
          else
            arch = "arm64"
            sdk = `xcrun --sdk iphoneos --show-sdk-path`.chomp
            success_indicator = File.join(Dir.pwd, ".mundler_compiled_successfully")
          end

          return if File.file?(success_indicator)

          env = {
            "CC" => `which clang`.chomp,
            "AR" => `which ar`.chomp,
            "CFLAGS" => "-O3 -arch #{arch} -isysroot #{sdk} -mios-version-min=#{minimum_ios_version}",
            "LDFLAGS" => "-arch #{arch} -isysroot #{sdk} -miphoneos-version-min=#{minimum_ios_version} -L#{sdk}/usr/include -lz",
          }

          FileUtils.mkdir_p(File.join(output_build_dir, "lib"))

          command = [
            "git add . -A",
            "git reset --hard v1.4.22",
            "git submodule update --init --recursive",
            "./configure --host=\"#{host}\" --prefix \"#{output_build_dir}\"",
            "make clean",
            "make",
            "make install"
          ].join(" && ")

          ::Mundler::SDL.log_wrap(env, command) || begin
            FileUtils.remove_dir(output_build_dir) if File.directory?(output_build_dir)
            raise(Mundler::CompilationError)
          end

          FileUtils.touch(success_indicator)
        ensure
          # Because of the `reset --hard`
          clone_success_indicator = File.join(Dir.pwd, ".mundler_cloned_successfully")
          FileUtils.touch(clone_success_indicator)
        end
      end
    end
  end
end
