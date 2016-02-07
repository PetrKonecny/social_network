class AddGroupToStatus < ActiveRecord::Migration
  def change
    add_reference :statuses, :group, index: true, foreign_key: true
  end
end
