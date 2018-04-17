module FileExtractor

    require 'find'
  
    class CarthageDeterminer
  
      def self.find_cartfile_directory(path)
        cartfile_path = Find.find(path).select do |path| 
            File.basename(path) == "Cartfile"
        end.each do |path|
            File.expand_path(path)
        end
        if cartfile_path.first
          return File.dirname(cartfile_path.first)
        else
          return nil
        end
      end

      def self.directory_contains_cartfile_resolved(path)
        cartfile_resolved_path = Find.find(path).select do |path|
          File.basename(path) == "Cartfile.resolved"
        end
        return !cartfile_resolved_path.empty?
      end


  
    end
  
  end