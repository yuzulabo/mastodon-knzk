class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false, default: '', limit:191
      t.integer :account_id, null: false

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
