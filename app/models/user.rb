class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :rooms, through: :memberships
  has_many :smaller_one_to_one_chats, class_name: "OneToOneChat", foreign_key: :smaller_user_id, inverse_of: :smaller_user, dependent: :destroy
  has_many :larger_one_to_one_chats, class_name: "OneToOneChat", foreign_key: :smaller_user_id, inverse_of: :smaller_user, dependent: :destroy
end
