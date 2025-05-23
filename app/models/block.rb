class Block < ApplicationRecord
  belongs_to :blocker, class_name: "User", inverse_of: :blocks_by_self
  belongs_to :blockee, class_name: "User", inverse_of: :blocks_by_other
end
