class MessageRead < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :message
  belongs_to :membership

  # TODO: 既読も stream でつけるようにしたい
end
