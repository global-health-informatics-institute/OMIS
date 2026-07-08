# frozen_string_literal: true

# Add a reference column to store supporting data i.e url
class AddReferenceToProjectTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :project_tasks, :reference, :text, null: true
  end
end
