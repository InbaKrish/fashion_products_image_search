class WeaviateCreateFashionProductClass < ActiveRecord::Migration[7.0]
  def up
    class_name = 'FashionProduct'        # Name of the class (in vector DB)
    weaviate_client = WeaviateClient.create_client
    begin
      if weaviate_client.schema.get(class_name: class_name) != "Not Found"
        puts "Class '#{class_name}' already exists"
        return
      end
 
      weaviate_client.schema.create(
          class_name: class_name,
          vectorizer: 'img2vec-neural',   # Module used to vectorize the images
          module_config: {
            'img2vec-neural': {           # Weaviate's img2vec module
              'imageFields': [
                'image'
              ]
            }
          },
          properties: [                   # Properties of the VDB class
            {
              'name': 'image',
              'dataType': ['blob']
            },
            {
              'name': 'fashion_prd_id',
              'dataType': ['int']
            }
        ]
      )
    rescue => exception
      if weaviate_client.schema.get(class_name: class_name) != "Not Found"
        weaviate_client.schema.delete(class_name: class_name)
      end
      raise exception
    end
  end

  def down
    weaviate_client = WeaviateClient.create_client
    if weaviate_client.schema.get(class_name: 'FashionProduct') != "Not Found"
      weaviate_client.schema.delete(class_name: 'FashionProduct')
    end
  end
end
