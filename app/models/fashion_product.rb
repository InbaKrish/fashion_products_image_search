# frozen_string_literal = true

class FashionProduct < ApplicationRecord
  has_one_attached :product_image
end
