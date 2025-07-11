class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :sent_messages, dependent: :destroy, class_name: "Message", foreign_key: :from_id, inverse_of: :from
  has_many :sent_reactions, dependent: :destroy, class_name: "Reaction", foreign_key: :from_id, inverse_of: :from
  has_many :message_reads, dependent: :destroy

  delegate :name, :latest_key_pair, to: :user
end
