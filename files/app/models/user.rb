class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  # attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :role_id

  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates :email,
            :uniqueness => true,
            :format => {:with => EMAIL_REGEX}

  validates_presence_of :name

  belongs_to :role

end