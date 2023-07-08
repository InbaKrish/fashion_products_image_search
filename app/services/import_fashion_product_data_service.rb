# frozen_string_literal = true
require 'csv'

class ImportFashionProductDataService
  def initialize(dataset_path, metadata_file_name, image_dir)
    @dataset_path = dataset_path
    @csv_metadata_path = File.join(@dataset_path, metadata_file_name)
    @image_dir = File.join(@dataset_path, image_dir)
  end

  def call
    process_csv_data_import
  end

  private

  def process_csv_data_import
    line_number = 0

    begin
      CSV.foreach(@csv_metadata_path, headers: true) do |row_data|
        create_fashion_prd_from_metadata(format_metadata(row_data))
        line_number += 1
      end
    rescue StandardError => e
      puts "Error parsing CSV at line #{line_number}: #{e.message}"
    end
  end

  # Create a new record with the image from CSV metadata
  def create_fashion_prd_from_metadata(metadata)
    fsprd = create_fashion_prd_with(attributes: metadata)

    # Image attachment process
    image_file  = File.join(@image_dir, fsprd.p_id.to_s + '.jpg')
    puts image_file
    return unless File.exist?(image_file)

    fsprd.product_image.attach(io: File.open(image_file), filename: File.basename(image_file))
    fsprd.save
    puts "#{fsprd.name} created successfully."
  end

  def format_metadata(row_data)
    metadata = row_data.to_hash
    metadata = metadata.transform_keys do |k|
      case k.to_s
      when 'productDisplayName'
        'name'
      when 'id'
        'p_id'
      else
        k.to_s.underscore
      end
    end
    metadata
  end

  def create_fashion_prd_with(attributes:)
    FashionProduct.new.tap do |record|
      attributes.each do |k, v|
        next unless record.respond_to?(k + '=')

        record.send(k + '=', v)
      end
    end
  end
end
