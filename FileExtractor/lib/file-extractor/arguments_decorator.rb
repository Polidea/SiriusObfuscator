module FileExtractor
  
  class ArgumentsDecorator

    def self.optionize(options)
      options.map do |option| 
        [option.first.gsub("--", "-"), option.last]
      end
    end
   
    def self.update_argv(argv, default_arg, options)
      if argv.empty?
        return [default_arg]
      end
      options.each do |option| 
        argv = update_arg_syntax(argv, option.first)
      end
      argv
    end

    private

    def self.update_arg_syntax(argv, param)
      param_index = argv.index(param)
      if param_index.nil?
       return argv
      end
      elem = argv[param_index + 1]
      if elem.nil?
       argv[param_index] = "-#{param}"
       return argv
      end
      argv[param_index] = "-#{param}=#{elem}"
      argv = argv - [elem]
      argv
    end

  end

end
