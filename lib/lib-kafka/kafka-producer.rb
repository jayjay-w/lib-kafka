# frozen_string_literal: true

require "rdkafka"
require "json"
require "singleton"
require "securerandom"

module LibKafka
  # A shared Kafka producer class that uses the singleton pattern.
  # This ensures there is only one instance of the producer across the application.
  class KafkaProducer
    include Singleton

    def initialize
      # The configuration is now handled by the gem's initializer
      # in the host application.
      puts "Initializing KafkaProducer with brokers: #{LibKafka.config.kafka_servers}"
      config = {
        "bootstrap.servers": LibKafka.config.kafka_servers
      }
      @producer = Rdkafka::Config.new(config).producer
    end

    # Method to publish a message with metadata to a specific topic.
    def produce(topic, message)
      # Get the hostname of the machine running the service.
      hostname = `hostname`.strip

      # Add metadata to the message payload, using the configured service name.
      payload_with_metadata = {
        data: message,
        metadata: {
          sent_from: LibKafka.config.service_name,
          timestamp: Time.now.utc.iso8601,
          hostname: hostname,
          correlation_id: SecureRandom.uuid
        }
      }

      # Convert the entire payload to JSON.
      payload = payload_with_metadata.to_json

      @producer.produce(topic: topic, payload: payload, partition: -1)
      @producer.flush(10) # Ensure message is sent
      puts "Published message to '#{topic}': #{payload}"
    end
  end
end
