class StampSet < ApplicationRecord
  has_many :stamps, dependent: :destroy
  has_many :stamp_ownerships, dependent: :destroy
end
