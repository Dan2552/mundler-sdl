module Mundler
  module SDL
    module Host
      module All
        def self.compile(clone_directory, output_build_dir, options = {})
          FileUtils.cd(clone_directory)

          success_indicator = File.join(clone_directory, ".mundler_compiled_successfully")
          return if File.file?(success_indicator)

          FileUtils.mkdir_p(output_build_dir)

          ::Mundler::SDL.log_wrap("./configure --prefix=#{output_build_dir} && make -j4 && make install") || begin
            FileUtils.remove_dir(output_build_dir) if File.directory?(output_build_dir)
            raise(Mundler::CompilationError)
          end

          FileUtils.touch(success_indicator)
        end
      end
    end
  end
end
