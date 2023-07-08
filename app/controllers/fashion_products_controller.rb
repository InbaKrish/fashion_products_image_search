# frozen_strong_literal = true

class FashionProductsController < ApplicationController
  def index
    byebug
    @fashion_products = FashionProduct.limit(20)
  end
end
