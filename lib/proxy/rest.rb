require 'yaml'
require 'sinatra/base'

module SmartProxy
  class API < Sinatra::Base

    dir = File.expand_path(File.dirname(__FILE__) + "/../../web")

    set :public_folder, "#{dir}/assets"
    set :views,  "#{dir}/views"
    set :root, "#{dir}/public"
    set :locales, "#{dir}/locales"

    get "/version" do
      content_type :json
      { :version => SmartProxy::VERSION }.to_json
    end

    get "/components" do
      @queues = Sidekiq::Stats.new.queues
      slim :queues
    end

  end
end
