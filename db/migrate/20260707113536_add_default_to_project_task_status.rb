# frozen_string_literal: true

# Add Open and Closed as default values for task_status in ProjectTask model
class AddDefaultToProjectTaskStatus < ActiveRecord::Migration[7.0]
  def change
    change_column_default :project_tasks, :task_status, from: nil, to: 'Open'
  end
end
