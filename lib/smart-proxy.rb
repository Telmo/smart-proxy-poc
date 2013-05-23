require "proxy/version"
require 'proxy/logging'
require 'proxy/api'

module SmartProxy


  DEFAULTS = {
  :logfile => "/var/log/smart-proxy.log",
  :logformat => "json",
  }


  def self.options
    @options ||= DEFAULTS.dup
  end

  def self.options=(opts)
    @options = opts
  end

  def self.configure_server
    yield self if server?
  end

  def self.server_middleware
    @server_chain ||= Processor.default_middleware
    yield @server_chain if block_given?
    @server_chain
  end

  def self.load_json(string)
    JSON.parse(string)
  end

  def self.dump_json(object)
    JSON.generate(object)
  end

  def self.logger
    Sidekiq::Logging.logger
  end

  def self.logger=(log)
    Sidekiq::Logging.logger = log
  end

end
