class User < ActiveRecord::Base
  include Devise::Models::DatabaseAuthenticatable

  devise :cas_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :role

end