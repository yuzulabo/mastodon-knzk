class MakeUrisNullableInStatuses < ActiveRecord::Migration
  def change
    change_column :statuses, :uri, :string, null: true, default: nil, limit: 191
  end
end
