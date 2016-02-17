class AddGenderAndStatusToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :gender, :integer
    add_column :profiles, :relationship_status, :integer
  end
end
