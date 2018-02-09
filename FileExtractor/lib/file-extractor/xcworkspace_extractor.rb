module FileExtractor

  require 'find'

  class XcworkspaceExtractor

    def self.extract_projects_and_dependency_schemes(xcworkspaces, xcodeprojs)
      projects = []
      dependency_schemes = []

      if xcworkspaces.empty?
        projects = xcodeprojs

      elsif xcworkspaces.count > 1
        puts "We support only single .xcworkspace right now"
      
      elsif xcworkspaces.count == 1  
        workspace_path = xcworkspaces.first
        workspace = Xcodeproj::Workspace.new_from_xcworkspace(workspace_path)
        is_cocoapods_project = !workspace.schemes["Pods"].nil?

        if is_cocoapods_project
          scheme = Xcodeproj::Project.open(workspace.schemes["Pods"]).targets.map do |target|
            target.name
          end.select do |target|
            target.start_with?("Pods")
          end.sort.first
          dependency_schemes << { :workspace => workspace_path, :scheme => scheme }
          projects = workspace.schemes.select do |key, value|
            key != "Pods" && xcodeprojs.include?(value)
          end.values.uniq
        end

      end
      
      return projects, dependency_schemes
    end 

    private 

  end

end