class OneToOneChat < ApplicationRecord
  belongs_to :smaller_user, class_name: "User", inverse_of: :smaller_one_to_one_chats
  belongs_to :larger_user, class_name: "User", inverse_of: :larger_one_to_one_chats
  has_one :room, as: :joinable, touch: true

  before_save :normalize_user_id
  after_create :create_memberships

  def display_name_for(user)
    other_for(user).name
  end

  def read_count_text(message, reader)
    return "" if message.from != reader

    count = message.message_reads.where.not(membership: reader).count
    if count > 0
      "既読"
    else
      ""
    end
  end

  def viewable_messages_for(membership)
    other = other_for(membership.user)
    if membership.user.block_by_self?(other)
      room.messages.where(from: membership)
    else
      room.messages
    end
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
    smaller_user.memberships.create_or_find_by!(room:)
    larger_user.memberships.create_or_find_by!(room:)
  end

  def other_for(user)
    if smaller_user_id == user.id
      larger_user
    else
      smaller_user
    end
  end
end
