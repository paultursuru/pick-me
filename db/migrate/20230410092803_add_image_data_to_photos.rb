class AddImageDataToOptionsAndInspirations < ActiveRecord::Migration[7.0]
  def change
    add_column :options, :image_data, :text
    add_column :inspirations, :image_data, :text
  end
end
