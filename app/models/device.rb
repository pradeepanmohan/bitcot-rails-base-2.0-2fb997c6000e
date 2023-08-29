class Device < ApplicationRecord

  belongs_to :user

  enum identifier: [:ios, :android]

  validates :push_token, presence: true, uniqueness: true

  scope :current_devices_count, -> (push_token) {where(push_token: push_token).count}

end
