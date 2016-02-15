class AddTypeGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :type_group, :string, :default => 'private', :null => false
  end

  def self.down
    remove_column :groups, :type_group
  end
end
