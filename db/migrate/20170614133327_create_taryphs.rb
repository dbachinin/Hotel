class CreateTaryphs < ActiveRecord::Migration[5.1]
  def change
    create_table :taryphs do |t|
      t.date :udate
      t.date :edate
      t.float :index

      t.timestamps
    end
  end
end
