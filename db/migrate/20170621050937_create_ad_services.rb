class CreateAdServices < ActiveRecord::Migration[5.1]
  def change
    create_table :ad_services do |t|
      t.string :name
      t.string :price
      t.boolean :enable

      t.timestamps
    end
  end
end
