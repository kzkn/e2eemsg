class Room < ApplicationRecord
  delegated_type :joinable, types: %w[OneToOneChat]
  has_many :memberships, dependent: :destroy
  has_many :messages, dependent: :destroy

  delegate :display_name_for, to: :joinable

  def read_count_text(message, reader)
    return "" if message.from != reader

    count = message.message_reads.where.not(membership: reader).count
    if count > 0
      %(既読#{show_read_count? ? ": #{count}" : ""})
    else
      ""
    end
  end

  def viewable_messages_for(membership)
    blockee_ids = membership.user.blocks_by_self.select(:blockee_id)
    messages.joins(:from).merge(Membership.where.not(user_id: blockee_ids))
  end

  private

  def show_read_count?
    memberships.count > 2
  end
end
