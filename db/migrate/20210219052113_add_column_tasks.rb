class AddColumnTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :deadline, :datetime, null: false, default: (Date.new(2021, 3, 1))
  end
end
