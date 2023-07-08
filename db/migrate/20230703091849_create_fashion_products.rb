class CreateFashionProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :fashion_products do |t|
      t.integer :p_id
      t.string :gender
      t.string :master_category
      t.string :sub_category
      t.string :article_type
      t.string :base_colour
      t.string :name
      t.string :usage

      t.timestamps
    end
  end
end
