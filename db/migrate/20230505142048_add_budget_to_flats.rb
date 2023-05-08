class AddBudgetToFlats < ActiveRecord::Migration[7.0]
  def change
    add_column :flats, :budget, :integer
  end
end
