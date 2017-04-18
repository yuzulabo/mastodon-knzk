class CreateDomainBlocks < ActiveRecord::Migration[5.0]
  def change
    create_table :domain_blocks do |t|
      t.string :domain, null: false, default: '', limit: 191
      t.timestamps
    end

    add_index :domain_blocks, :domain, unique: true
  end
end
