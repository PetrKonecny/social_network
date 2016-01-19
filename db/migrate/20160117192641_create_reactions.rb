class CreateReactions < ActiveRecord::Migration
  def change
    create_table :reactions do |t|
      t.integer :reaction_type
      t.references :rateable, polymorphic: true, index: true
      t.references :user, foreign_key: true, index: true
      t.timestamps null: false
    end
  end
end
