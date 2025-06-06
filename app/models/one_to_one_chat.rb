class OneToOneChat < ApplicationRecord
  include Joinable

  belongs_to :smaller_user, class_name: "User", inverse_of: :smaller_one_to_one_chats
  belongs_to :larger_user, class_name: "User", inverse_of: :larger_one_to_one_chats

  before_save :normalize_user_id
  after_create :create_memberships

  def display_name_for(user)
    other_for(user).name
  end

  private

  def normalize_user_id
    if smaller_user_id > larger_user_id
      tmp = smaller_user_id
      self.smaller_user_id = larger_user_id
      self.larger_user_id = tmp
    end
  end

  def create_memberships
    room.memberships.build(user: smaller_user)
    room.memberships.build(user: larger_user)
  end

  def other_for(user)
    if smaller_user_id == user.id
      larger_user
    else
      smaller_user
    end
  end

  class << self
    def find_or_create_for_users(user1, user2)
      smaller, larger = user1.id < user2.id ? [user1, user2] : [user2, user1]
      chat = find_by(smaller_user: smaller, larger_user: larger)
      return chat if chat.present?

      room = Room.new
      chat = OneToOneChat.new(room:, smaller_user: smaller, larger_user: larger)
      room.joinable = chat
      room.save!
      chat
    end
  end
end
