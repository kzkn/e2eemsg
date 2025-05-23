class StampMessage < ApplicationRecord
  include Sendable

  belongs_to :stamp

  def render_for(membership, view_context)
    view_context.image_tag(stamp.image, style: "width:125px;height:auto")
  end

  def valid_to_send?(message)
    message.from.user.stamp_ownerships.exists?(stamp_set: stamp.stamp_set)
  end
end
