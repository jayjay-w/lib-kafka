# frozen_string_literal: true

require "rdkafka"
require "json"
require "securerandom"
require "./lib-kafka/version"

# Main module for the gem. It provides the configuration and the Kafka producer class.
module LibKafka
  class << self
    # A public method to configure the gem.
    def configure
      yield(config)
    end

    # Returns the configuration object.
    def config
      @config ||= Config.new
    end
  end

  # Configuration class to hold settings for the Kafka producer.
  class Config
    attr_accessor :kafka_servers, :service_name

    def initialize
      @kafka_servers = "kafka:29092"
      @service_name = "unknown-service"
    end
  end

  # This class handles the production of messages to Kafka.
  class KafkaProducer
    # Class-level variable to hold the producer instance.
    @@producer = nil

    # Method to initialize the Kafka producer with the gem's configuration.
    def self.producer
      return @@producer unless @@producer.nil?

      # Use the configured bootstrap servers
      config = {
        "bootstrap.servers": LibKafka.config.kafka_servers
      }
      @@producer = Rdkafka::Config.new(config).producer
    end

    # Method to publish a message with metadata to a specific topic.
    def self.produce(topic, message)
      # Get the hostname of the machine running the service
      hostname = `hostname`.strip

      # Add metadata to the message payload, using the configured service name
      payload_with_metadata = {
        data: message,
        metadata: {
          sent_from: LibKafka.config.service_name,
          timestamp: Time.now.utc.iso8601,
          hostname: hostname,
          correlation_id: SecureRandom.uuid
        }
      }

      # Convert the entire payload to JSON
      payload = payload_with_metadata.to_json

      # Use the class-level producer instance
      producer.produce(topic: topic, payload: payload, partition: -1)
      producer.flush(10) # Ensure message is sent
      puts "Published message to '#{topic}': #{payload}"
    rescue Rdkafka::RdkafkaError => e
      puts "Error producing message: #{e.message}"
    end
  end
end
