class ImageMessage < ApplicationRecord
  include Sendable

  has_one_attached :image

  def render_for(membership, view_context)
    view_context.image_tag(image, style: "width:150px;height:auto")
  end
end
