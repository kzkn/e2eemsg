module Sendable
  extend ActiveSupport::Concern

  included do
    has_one :message, as: :sendable, touch: true
  end

  def valid_to_send?(message)
    true
  end
end
