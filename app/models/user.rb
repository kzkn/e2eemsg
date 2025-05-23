class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :rooms, through: :memberships
  has_many :smaller_one_to_one_chats, class_name: "OneToOneChat", foreign_key: :smaller_user_id, inverse_of: :smaller_user, dependent: :destroy
  has_many :larger_one_to_one_chats, class_name: "OneToOneChat", foreign_key: :larger_user_id, inverse_of: :larger_user, dependent: :destroy
  has_many :stamp_ownerships, dependent: :destroy
  has_many :owned_stamp_sets, through: :stamp_ownerships, source: :stamp_set
end
