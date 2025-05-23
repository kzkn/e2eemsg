class Stamp < ApplicationRecord
  belongs_to :stamp_set

  has_one_attached :image
end
