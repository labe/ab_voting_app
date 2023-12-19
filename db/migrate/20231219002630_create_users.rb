class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :zip_code, null: false
      t.timestamps
    end
  end
end
