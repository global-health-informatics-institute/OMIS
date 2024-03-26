# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_03_24_144057) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affiliations", primary_key: "affliation_id", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.integer "department_id", null: false
    t.date "started_on", null: false
    t.date "ended_on"
    t.boolean "is_terminated", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "asset_categories", force: :cascade do |t|
    t.string "category", null: false
    t.text "description"
    t.boolean "voided", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assets", primary_key: "asset_id", force: :cascade do |t|
    t.integer "asset_category_id", null: false
    t.string "tag_id", null: false
    t.string "description", null: false
    t.string "make"
    t.string "model"
    t.string "serial_number"
    t.string "location", null: false
    t.float "value", null: false
    t.string "status", null: false
    t.string "disposal_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "branches", primary_key: "branch_id", force: :cascade do |t|
    t.string "branch_name", null: false
    t.string "country", null: false
    t.string "city", null: false
    t.string "location", null: false
    t.integer "created_by"
    t.integer "closed_by"
    t.boolean "is_open", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", primary_key: "department_id", force: :cascade do |t|
    t.integer "branch_id", null: false
    t.string "department_name", null: false
    t.boolean "is_active", default: true
    t.integer "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "designation_workflow_state_actions", force: :cascade do |t|
    t.integer "workflow_state_id", null: false
    t.integer "designation_id", null: false
    t.boolean "voided", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "designations", primary_key: "designation_id", force: :cascade do |t|
    t.integer "department_id", null: false
    t.string "designated_role", null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employee_designations", primary_key: "employee_designation_id", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.integer "designation_id", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", primary_key: "employee_id", force: :cascade do |t|
    t.integer "person_id", null: false
    t.date "employment_date", null: false
    t.boolean "still_employed", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "departure_date"
    t.date "#<ActiveRecord::ConnectionAdapters::PostgreSQL::TableDefinition"
  end

  create_table "global_properties", primary_key: "property_id", force: :cascade do |t|
    t.string "property"
    t.string "property_value"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leave_summaries", primary_key: "leave_summary_id", force: :cascade do |t|
    t.string "leave_type", null: false
    t.integer "employee_id", null: false
    t.float "leave_days_total", null: false
    t.float "leave_days_balance", null: false
    t.integer "financial_year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", primary_key: "person_id", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "middle_name"
    t.string "last_name", null: false
    t.date "birth_date", null: false
    t.string "gender", null: false
    t.string "marital_status", null: false
    t.string "primary_phone"
    t.string "alt_phone"
    t.string "email_address"
    t.string "official_email"
    t.string "postal_address"
    t.string "residential_address"
    t.string "landmark"
    t.boolean "voided", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_task_assignments", primary_key: "project_task_assignment_id", force: :cascade do |t|
    t.integer "project_task_id", null: false
    t.integer "assigned_to", null: false
    t.boolean "revoked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_tasks", primary_key: "project_task_id", force: :cascade do |t|
    t.integer "project_id", null: false
    t.string "task_description", null: false
    t.decimal "estimated_duration"
    t.datetime "deadline"
    t.string "task_status"
    t.integer "performed_by"
    t.boolean "voided", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_teams", primary_key: "project_team_id", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "employee_id", null: false
    t.float "allocated_effort", default: 0.0
    t.date "start_date", null: false
    t.date "end_date"
    t.boolean "voided", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", primary_key: "project_id", force: :cascade do |t|
    t.string "project_name", null: false
    t.string "short_name"
    t.string "project_description", null: false
    t.integer "manager", null: false
    t.integer "created_by"
    t.integer "closed_by"
    t.boolean "is_active", default: true, null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "report_statistics", primary_key: "statistic_id", force: :cascade do |t|
    t.date "period_start", null: false
    t.date "period_end", null: false
    t.string "period_label", null: false
    t.string "statistic_description", null: false
    t.decimal "statistic_value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requisition_items", primary_key: "requisition_item_id", force: :cascade do |t|
    t.integer "requisition_id", null: false
    t.decimal "quantity"
    t.decimal "value"
    t.string "item_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requisition_notes", force: :cascade do |t|
    t.integer "requisition_id", null: false
    t.integer "user_id", null: false
    t.text "note"
    t.boolean "voided", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requisitions", primary_key: "requisition_id", force: :cascade do |t|
    t.string "purpose", null: false
    t.integer "initiated_by", null: false
    t.datetime "initiated_on", null: false
    t.string "requisition_type", null: false
    t.integer "reviewed_by"
    t.integer "approved_by"
    t.integer "workflow_state_id", null: false
    t.boolean "voided", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "supervisions", primary_key: "supervision_id", force: :cascade do |t|
    t.integer "supervisor", null: false
    t.integer "supervisee", null: false
    t.date "started_on"
    t.date "ended_on"
    t.boolean "is_terminated", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timesheet_tasks", force: :cascade do |t|
    t.integer "timesheet_id", null: false
    t.integer "project_id", null: false
    t.date "task_date", null: false
    t.string "description"
    t.decimal "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timesheets", primary_key: "timesheet_id", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.date "timesheet_week", null: false
    t.datetime "submitted_on"
    t.integer "approved_by"
    t.datetime "approved_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state"
  end

  create_table "token_logs", primary_key: "token_id", force: :cascade do |t|
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", primary_key: "user_id", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.string "username", null: false
    t.string "password_digest"
    t.string "password_confirmation"
    t.datetime "activated_at", precision: nil
    t.datetime "deactivated_at", precision: nil
    t.boolean "reset_needed", default: false, null: false
    t.boolean "activated", default: false
    t.datetime "last_login", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workflow_processes", primary_key: "workflow_process_id", force: :cascade do |t|
    t.string "workflow", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
  end

  create_table "workflow_state_actions", force: :cascade do |t|
    t.integer "workflow_state_id", null: false
    t.string "state_action", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workflow_state_actors", force: :cascade do |t|
    t.integer "workflow_state_id", null: false
    t.integer "employee_designation_id", null: false
    t.boolean "voided", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workflow_state_transitioners", force: :cascade do |t|
    t.integer "workflow_state_transition"
    t.boolean "owner"
    t.integer "stakeholder"
    t.boolean "voided"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workflow_state_transitions", force: :cascade do |t|
    t.integer "workflow_state_id", null: false
    t.integer "next_state", null: false
    t.boolean "voided", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "action", null: false
    t.boolean "by_owner", default: false
  end

  create_table "workflow_states", primary_key: "workflow_state_id", force: :cascade do |t|
    t.integer "workflow_process_id"
    t.string "state", null: false
    t.string "description"
    t.boolean "voided", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "departments", "branches", primary_key: "branch_id"
  add_foreign_key "employees", "people", primary_key: "person_id"
end
