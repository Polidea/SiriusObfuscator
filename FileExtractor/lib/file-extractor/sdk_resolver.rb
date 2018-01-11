module FileExtractor

  class SdkResolver

    def self.sdk_path(data)
      path = %x{ xcrun --sdk #{data.sdk.name} --show-sdk-path }
      path.sub("\n", "")
    end

    def self.update_frameworks_paths(data)
      data.explicitelyLinkedFrameworks.map do |framework|
        framework.path = framework.path.sub("${SDKROOT}", data.sdk.path)
        framework
      end
    end

  end

end