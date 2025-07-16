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

ActiveRecord::Schema[7.0].define(version: 2025_07_16_140635) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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

  create_table "initial_states", primary_key: "initial_state_id", force: :cascade do |t|
    t.integer "workflow_process_id"
    t.integer "workflow_state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventory_item_categories", primary_key: "inventory_item_category_id", force: :cascade do |t|
    t.string "category", null: false
    t.boolean "voided", default: false, null: false
    t.integer "created_by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventory_item_issues", force: :cascade do |t|
    t.integer "requisition_id", null: false
    t.integer "inventory_item_id", null: false
    t.decimal "quantity_issued", default: "0.0", null: false
    t.date "issue_date", null: false
    t.integer "issued_by", null: false
    t.integer "issued_to", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventory_item_thresholds", primary_key: "inventory_item_threshold_id", force: :cascade do |t|
    t.integer "inventory_item_id", null: false
    t.decimal "minimum_quantity", default: "0.0"
    t.decimal "maximum_quantity", default: "0.0"
    t.boolean "voided", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventory_item_types", primary_key: "inventory_item_type_id", force: :cascade do |t|
    t.integer "inventory_item_category_id", null: false
    t.string "item_name", null: false
    t.string "manufacturer", null: false
    t.integer "created_by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventory_items", primary_key: "inventory_item_id", force: :cascade do |t|
    t.integer "item_type_id", null: false
    t.integer "quantity", default: 0, null: false
    t.integer "quantity_used", default: 0, null: false
    t.string "supplier", null: false
    t.decimal "unit_price", precision: 10, scale: 2
    t.string "storage_location"
    t.integer "created_by", null: false
    t.integer "voided_by"
    t.boolean "voided", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leave_requests", primary_key: "leave_request_id", force: :cascade do |t|
    t.string "leave_type", null: false
    t.integer "employee_id", null: false
    t.datetime "start_on", null: false
    t.datetime "end_on", null: false
    t.integer "stand_in", null: false
    t.integer "reviewed_by"
    t.boolean "reviewed_on"
    t.integer "approved_by"
    t.boolean "approved_on"
    t.integer "status", null: false
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

  create_table "petty_cash_comments", force: :cascade do |t|
    t.text "comment"
    t.decimal "used_amount", precision: 10, scale: 2
    t.bigint "requisition_id", null: false
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

  create_table "purchase_request_attachments", force: :cascade do |t|
    t.bigint "requisition_id", null: false
    t.boolean "voided"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stakeholder_id"
    t.string "supplier"
    t.string "item_requested"
    t.boolean "requires_ipc", default: false
    t.index ["stakeholder_id"], name: "index_purchase_request_attachments_on_stakeholder_id"
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
    t.integer "project_id"
    t.integer "department_id"
  end

  create_table "stakeholders", primary_key: "stakeholder_id", force: :cascade do |t|
    t.string "stakeholder_name", null: false
    t.string "contact_email"
    t.boolean "is_partner", default: false
    t.boolean "is_donor", default: false
    t.string "donation_frequency"
    t.string "partnership_tier"
    t.boolean "voided", default: false
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

  create_table "travel_requests", force: :cascade do |t|
    t.bigint "requisition_id", null: false
    t.integer "distance"
    t.boolean "voided", default: false
    t.text "traveler_names"
    t.datetime "departure_date", precision: nil
    t.datetime "return_date", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "destination"
    t.integer "asset_id"
    t.index ["asset_id"], name: "index_travel_requests_on_asset_id"
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
    t.integer "stakeholder"
    t.date "start_date"
    t.date "end_date"
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
    t.boolean "by_supervisor", default: false
  end

  create_table "workflow_states", primary_key: "workflow_state_id", force: :cascade do |t|
    t.integer "workflow_process_id"
    t.string "state", null: false
    t.string "description"
    t.boolean "voided", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "departments", "branches", primary_key: "branch_id"
  add_foreign_key "employees", "people", primary_key: "person_id"
  add_foreign_key "petty_cash_comments", "requisitions", primary_key: "requisition_id"
  add_foreign_key "purchase_request_attachments", "requisitions", primary_key: "requisition_id"
  add_foreign_key "purchase_request_attachments", "stakeholders", primary_key: "stakeholder_id"
  add_foreign_key "requisitions", "departments", primary_key: "department_id"
  add_foreign_key "travel_requests", "assets", primary_key: "asset_id"
  add_foreign_key "travel_requests", "requisitions", primary_key: "requisition_id"
end
