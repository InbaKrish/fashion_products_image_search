# frozen_strong_literal = true

class FashionProductsController < ApplicationController
  def index
    @fashion_products = FashionProduct.order('RANDOM()').limit(20)
  end

  def search
    @fashion_products = search_by_image

    if turbo_frame_request?
      render partial: 'fashion_products', locals: { fashion_products: @fashion_products }
    else
      render :index
    end
  end

  private

  def search_params
    params.permit(:product_image)
  end

  def search_by_image
    base64_image = Base64.encode64(search_params[:product_image].read)
    FashionProduct.products_from_img(base64_img: base64_image)
  end
end
