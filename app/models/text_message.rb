class TextMessage < ApplicationRecord
  include Sendable

  def render_for(membership, view_context)
    body
  end
end
