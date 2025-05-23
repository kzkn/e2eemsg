class VideoMessage < ApplicationRecord
  include Sendable

  has_one_attached :video

  def render_for(membership, view_context)
    view_context.video_tag(video, controls: true, style: "width:250px;height:auto")
  end
end
