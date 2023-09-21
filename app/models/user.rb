class User < ApplicationRecord
    require 'securerandom'

    has_secure_password :password, validations: true
    validates :username, presence: true, uniqueness: true
    validates :password_digest , presence: true
    

    belongs_to :employee, foreign_key: :employee_id
    

    
end
