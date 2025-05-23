module Sendable
  extend ActiveSupport::Concern

  included do
    has_one :message, as: :sendable, touch: true
  end
end
