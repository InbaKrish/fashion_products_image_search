# frozen_string_literal = true

class FashionProduct < ApplicationRecord
  #### ASSOCIATIONS ####
  has_one_attached :product_image

  #### CLASS METHODS ####

  # Query through Weaviate DB with the image passed and returns the matching FashionProducts
  def self.products_from_img(base64_img:)
    return if base64_img.blank?

    wc = WeaviateClient.create_client
    prd_ids = wc.query.get(
      class_name: 'FashionProduct',
      limit: '20',
      offset: '1',
      near_image: "{ image: \"#{base64_img}\" }",
      fields: 'fashion_prd_id'
    )
    prd_ids = prd_ids.map { |prd_val| prd_val['fashion_prd_id'] }

    FashionProduct.where(id: prd_ids)
  end
end
