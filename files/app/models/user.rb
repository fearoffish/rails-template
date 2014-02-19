class User < ActiveRecord::Base

  devise :cas_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
  validates :email,
            :uniqueness => true,
            :format => {:with => EMAIL_REGEX}

  validates_presence_of :name

  belongs_to :role

end