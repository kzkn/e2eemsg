class Reaction < ApplicationRecord
  belongs_to :message
  belongs_to :from, class_name: "Membership", inverse_of: :sent_reactions
  belongs_to :emoji

  # TODO: stream でリアルタイムに画面に反映したい
end
