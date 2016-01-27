class AddNameToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :name, :string, default: nil
  end

  def self.down
    remove_column :groups, :name
  end
end
