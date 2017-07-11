class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.string :name
      t.float :price
      t.boolean :enable

      t.timestamps
    end
  end
end
