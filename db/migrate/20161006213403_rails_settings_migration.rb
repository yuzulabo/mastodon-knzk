MIGRATION_BASE_CLASS = if ActiveRecord::VERSION::MAJOR >= 5
  ActiveRecord::Migration[5.0]
else
  ActiveRecord::Migration
end

class RailsSettingsMigration < MIGRATION_BASE_CLASS
  def self.up
    create_table :settings do |t|
      t.string     :var,    :null => false, limit: 191
      t.text       :value
      t.integer    :target_id
      t.string     :target_type, limit: 191
      t.timestamps :null => true
    end
    add_index :settings, [ :target_type, :target_id, :var ], :unique => true
  end

  def self.down
    drop_table :settings
  end
end
