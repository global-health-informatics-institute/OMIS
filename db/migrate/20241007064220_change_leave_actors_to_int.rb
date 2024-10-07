class ChangeLeaveActorsToInt < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      change_table :leave_requests do |t|
        dir.up {t.change :reviewed_by, 'integer USING CAST(reviewed_by AS integer)'}
        dir.up {t.change :approved_by, 'integer USING CAST(approved_by AS integer)'}
        dir.down {t.change :reviewed_by, :boolean}
        dir.down {t.change :approved_by, :boolean}
      end
    end
  end
end
