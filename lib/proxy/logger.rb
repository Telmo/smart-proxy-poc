require 'time'
require 'logger'
require 'json'

module SmartProxy
  module Logger
    def self.initialize_logger(log_file = SmartProxy.options[:logfile], log_format = SmartProxy.options[:logformat])
      @logger = Logger.new(log_file)
      @logger.level = Logger::INFO
      @logger.formatter = Pretty.new
      @logger
    end

    def self.logger
      @logger || initialize_logger
    end

    def self.logger=(log)
      @logger = (log ? log : Logger.new('/dev/null'))
    end

    def logger
      Sidekiq::Logging.logger
    end
  end

end
