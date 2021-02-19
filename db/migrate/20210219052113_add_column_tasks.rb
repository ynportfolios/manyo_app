class AddColumnTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :deadline, :datetime, null: false, default: -> { 'NOW()' }
  end
end
