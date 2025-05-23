class StampOwnership < ApplicationRecord
  belongs_to :stamp_set
  belongs_to :user
end
