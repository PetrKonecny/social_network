class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.string :surname
      t.integer :age

      t.timestamps null: false
    end
  end
end
