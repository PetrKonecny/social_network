class AddUnaccentExtension < ActiveRecord::Migration
  def self.up
    execute "create extension unaccent"
  end

  def self.down
    execute "drop extension unaccent"
  end
end
