module Mundler
  module SDL
    module Git
      def self.clone(repo, directory)
        FileUtils.mkdir_p(directory)
        FileUtils.cd(File.join(directory, ".."))

        success_indicator = File.join(directory, ".mundler_cloned_successfully")
        return if File.file?(success_indicator)

        FileUtils.remove_dir(directory)

        ::Mundler.with_clean_env do
          system(
            {
              # The {mundler gem path}/cached_git directory contains a binary called
              # `git` that will run instead of normal git, making a cache of a
              # clone.
              "PATH" => ([cached_git_dir] + ENV["PATH"].split(":")).join(":")
            },
            "git clone #{repo} #{File.basename(directory)} >/dev/null 2>&1"
          ) || raise("Failed to clone SDL2")
        end

        FileUtils.touch(success_indicator)
      end

      private

      def self.cached_git_dir
        mundler_path = Bundler.rubygems.find_name('mundler').first.full_gem_path
        dir = File.expand_path(File.join(mundler_path, "lib", "mundler", "cached_git"))
        raise "cached git not found" unless File.file?(File.join(dir, "git"))
        raise "cached git not found" unless File.file?(File.join(dir, "cached_git"))
        dir
      end
    end
  end
end
