class Room < ApplicationRecord
  delegated_type :joinable, types: %w[OneToOneChat]
  has_many :memberships, dependent: :destroy
  has_many :messages, dependent: :destroy

  delegate :display_name_for, :read_count_text, :viewable_messages_for, to: :joinable
end
