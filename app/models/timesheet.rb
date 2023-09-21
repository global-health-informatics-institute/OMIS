class Timesheet < ApplicationRecord
  has_many :timesheet_tasks, foreign_key: :timesheet_id
  has_one :employee, foreign_key: :employee_id
  has_one :project, foreign_key: :project_id
  def status
    if !self.approved_on.blank?
      return "Approved"
    elsif !self.submitted_on.blank?
      return "Pending Approval"
    else
      return "Pending Submit"
    end
  end

  def project_name
    self.project.project_name
  end
  def period
    return "#{self.timesheet_week.strftime('%d %b %Y')} to #{self.timesheet_week.end_of_week.strftime('%d %b %Y')}"
  end
  def full_details
    tasks = self.timesheet_tasks
    full_timesheet = {}
    (tasks || []).each do |task|
      if full_timesheet[task.project.short_name].nil?
        full_timesheet[task.project.short_name] = {'totals' => [0, 0, 0, 0, 0, 0, 0]}
        full_timesheet[task.project.short_name]["totals"][task.task_date.cwday] = task.duration.to_f
      else
        full_timesheet[task.project.short_name]["totals"][task.task_date.cwday] += task.duration.to_f
      end

      if full_timesheet[task.project.short_name][task.description].nil?
        full_timesheet[task.project.short_name][task.description] = [0, 0, 0, 0, 0, 0, 0]
      end
      full_timesheet[task.project.short_name][task.description][task.task_date.cwday] += task.duration.to_f
    end
    return full_timesheet
  end
end
