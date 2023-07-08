task import_fashion_prd_data_to_weaviate: :environment do
  weaviate_client = WeaviateClient.create_client

  FashionProduct.find_in_batches(batch_size: 500) do |fpds|
    # Generate array with FashionProduct Base64 encoded image and ID values
    objects_to_upload = fpds.map do |fpd|
      {
        class: 'FashionProduct',
        properties: {
          image: Base64.strict_encode64(fpd.product_image_attachment.download).to_s,
          fashion_prd_id: fpd.id
        }
      }
    end

    # Weaviate.io objects API batch import
    p weaviate_client.objects.batch_create(
      objects: objects_to_upload
    )
  end

  puts "-- Total FashionProduct records: #{FashionProduct.count}"

  uploaded_count = weaviate_client.query.aggs(
    class_name: 'FashionProduct', 
    fields: 'meta { count }',
  )

  puts "-- Total objects uploaded to Weaviate DB: #{uploaded_count}"
end
