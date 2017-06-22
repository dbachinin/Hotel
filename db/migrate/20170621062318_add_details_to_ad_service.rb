class AddDetailsToAdService < ActiveRecord::Migration[5.1]
  def change
    add_column :ad_services, :nameng, :string
  end
end
