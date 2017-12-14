lib = File.expand_path("..", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

module FileExtractor
  require 'xcodeproj'

  require 'file-extractor/command'
end
