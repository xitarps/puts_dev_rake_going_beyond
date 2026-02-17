require 'fileutils'

namespace :file do
    FILE_PATTERN = 'assets/**/*.png' # 'test_files/**/*.png' 
    ONE_MB = 1_000_000

    desc 'Optimze all PNG images insithe the folder'
    task :optimize_pngs, [:file_pattern] do |current_task, kwargs|
      file_pattern = kwargs&.file_pattern || FILE_PATTERN
      images = FileList[file_pattern]

      images.each do |image|
        if File.size(image) > ONE_MB
          puts "Optimizing #{image}"
          sh "optipng -o2 #{images}"
        end
      end
    end
end
