class User < ApplicationRecord
    require 'securerandom'

    has_secure_password :password, validations: true

    validates :username, presence: true, uniqueness: true
    validates :password_digest , presence: true
    belongs_to :employee, foreign_key: :employee_id

    def person
        return self.employee.person
    end

    def person_name
        return self.employee.person.first_name
    end

    def full_name
        person = self.employee.person
        return (person.first_name + ' ' + person.last_name)
    end
end
