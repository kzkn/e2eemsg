class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :rooms, through: :memberships
  has_many :smaller_one_to_one_chats, class_name: "OneToOneChat", foreign_key: :smaller_user_id, inverse_of: :smaller_user, dependent: :destroy
  has_many :larger_one_to_one_chats, class_name: "OneToOneChat", foreign_key: :larger_user_id, inverse_of: :larger_user, dependent: :destroy
  has_many :stamp_ownerships, dependent: :destroy
  has_many :owned_stamp_sets, through: :stamp_ownerships, source: :stamp_set
  has_many :blocks_by_self, class_name: "Block", foreign_key: :blocker_id, inverse_of: :blocker, dependent: :destroy
  has_many :blocks_by_other, class_name: "Block", foreign_key: :blockee_id, inverse_of: :blockee, dependent: :destroy
  has_many :key_pairs, dependent: :destroy

  def block_by_self?(other_user)
    blocks_by_self.find_by(blockee: other_user)
  end

  def latest_key_pair
    key_pairs.order(:id).last
  end
end
