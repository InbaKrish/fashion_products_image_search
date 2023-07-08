# frozen_string_literal = true
require "weaviate"

class WeaviateClient
  # Creates a new WeaviateClient instance with the specified configuration
  def self.create_client
    Weaviate::Client.new(
      url: "http://weaviate:8080"             # Use ENV variables incase on using cloud weaviate instance
    )
  end
end