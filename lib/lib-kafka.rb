# frozen_string_literal: true

require_relative "lib-kafka/version"
require_relative "lib-kafka/kafka_producer"

module LibKafka
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Config.new
    yield(config)
  end

  class Config
    attr_accessor :kafka_servers, :service_name
  end
end
