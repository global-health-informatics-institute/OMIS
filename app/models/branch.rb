class Branch < ApplicationRecord
    has_many :departments, :foreign_key => 'branch_id'

    def void(user)
        #this function sets the state of the branch to being closed i.e deleted.
        self.is_open = false
        self.closed_by = user
        return self.save
    end
end
