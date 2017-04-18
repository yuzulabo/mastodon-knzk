class AddBouncedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :bounced_at, :datetime
  end
end
