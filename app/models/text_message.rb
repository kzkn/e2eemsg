class TextMessage < ApplicationRecord
  include Sendable

  def render_for(membership)
    body
  end
end
