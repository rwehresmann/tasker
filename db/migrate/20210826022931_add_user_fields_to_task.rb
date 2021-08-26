class AddUserFieldsToTask < ActiveRecord::Migration[6.1]
  def change
    add_reference :tasks, :creator, null: false, foreign_key: { to_table: :users }
    add_reference :tasks, :assignee, null: true, foreign_key: { to_table: :users }
  end
end
