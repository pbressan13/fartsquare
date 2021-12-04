class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  geocoded_by :street_address
  after_validation :geocode # , if: :will_save_change_to_street_address?
  # validates :name, :email, :street_address, :city, :federal_unity, :description, presence: true, allow_blank: false
  validates :email, format: { with: Devise.email_regexp }
  # validates :street_address, length: { minimum: 6 }
  # validates :city, length: { minimum: 3 }
  # validates :federal_unity, length: { is: 2 }
  # validates :city, length: { minimum: 3 }
  # validates :description, length: { minimum: 10 }
end
