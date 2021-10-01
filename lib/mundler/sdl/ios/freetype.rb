module Mundler
  module SDL
    module IOS
      module Freetype
        def self.compile(clone_directory, output_build_dir, simulator: false)
          FileUtils.cd(clone_directory)

          if simulator
            success_indicator = File.join(Dir.pwd, ".mundler_compiled_simulator_successfully")
          else
            success_indicator = File.join(Dir.pwd, ".mundler_compiled_successfully")
          end

          return if File.file?(success_indicator)

          ios_sdk = `xcrun --sdk iphoneos --show-sdk-path`.chomp
          arch = "arm64"
          host = "aarch64-apple-darwin"
          minimum_ios_version = "10.0"

          env = {
            # "CC" => "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang", #
            "CC" => `which clang`.chomp,
            "AR" => `which ar`.chomp,
            "CFLAGS" => "-arch #{arch} -pipe -mdynamic-no-pic -Wno-trigraphs -fpascal-strings -O2 -Wreturn-type -Wunused-variable -fmessage-length=0 -fvisibility=hidden -miphoneos-version-min=#{minimum_ios_version} -I#{ios_sdk}/usr/include/libxml2 -isysroot #{ios_sdk}",
            "LDFLAGS" => "-arch #{arch} -isysroot #{ios_sdk} -miphoneos-version-min=#{minimum_ios_version}"
          }

          FileUtils.mkdir_p(File.join(output_build_dir, "lib"))

          command = [
            "git reset --hard VER-2-6-5",
            "git submodule update --init --recursive",
            "sh autogen.sh",
            "./configure --host=\"#{host}\" --enable-static=yes --enable-shared=no",
            "make clean",
            "make",
            "cp objs/.libs/libfreetype.a #{output_build_dir}/lib/libfreetype.a"
          ].join(" && ")

          ::Mundler::SDL.log_wrap(env, command) || begin
            FileUtils.remove_dir(output_build_dir) if File.directory?(output_build_dir)
            raise(Mundler::CompilationError)
          end

          FileUtils.cp_r(File.join(clone_directory, "include"), File.join(output_build_dir, "include"))
          # TODO: different sucess if simulator?
          FileUtils.touch(success_indicator)
        end
      end
    end
  end
end
