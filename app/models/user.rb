class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: [:google_oauth2]
  has_one_attached :avatar
  geocoded_by :street_address
  after_validation :geocode # , if: :will_save_change_to_street_address?

  validates :name, :email, presence: true, allow_blank: false
  validates :email, format: { with: Devise.email_regexp }

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data["email"]).first

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create(name: data["name"], email: data["email"],
                         password: password, password_confirmation: password,
                         avatar_url: data["image"])
    end
    user
  end
end
