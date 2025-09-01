require_relative "lib/lib-kafka/version"

Gem::Specification.new do |spec|
  spec.name          = "lib-kafka"
  spec.version       = LibKafka::VERSION
  spec.authors       = ["Jay Joshua"]
  spec.email         = ["jay@roam254.com"]

  spec.summary       = "A shared Ruby gem for producing messages to Kafka with common metadata."
  spec.description   = "This gem centralizes Kafka producer logic, including message metadata, for use across multiple microservices."
  spec.homepage      = "https://code.infra.jay.me/jay/paylio/lib-kafka"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + "/CHANGELOG.md"

  # Specify which files should be added to the gem when it's built.
  spec.files = Dir["{lib,exe,test,spec,features}/**/*", "README.md", "LICENSE.txt"]

  spec.add_runtime_dependency "rdkafka", "~> 0.11"
  spec.add_runtime_dependency "json", ">= 2.5"
end
