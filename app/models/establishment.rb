class Establishment < ApplicationRecord
  belongs_to :user_id
  has_many_attached :images
end
