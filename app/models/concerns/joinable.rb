module Joinable
  extend ActiveSupport::Concern

  included do
    has_one :room, as: :joinable, touch: true
  end
end
