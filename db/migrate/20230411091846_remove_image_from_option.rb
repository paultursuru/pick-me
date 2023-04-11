class RemoveImageFromOption < ActiveRecord::Migration[7.0]
  def change
    remove_column :options, :image_data, :text
    remove_column :inspirations, :image_data, :text
  end
end
