class TextMessageForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attr_accessor :message
  attribute :encrypted_messages

  def encrypted_messages_attributes=(attrs)
    self.encrypted_messages = attrs.values.map { EncryptedMessage.new(_1) }
  end

  def save!
    ApplicationRecord.transaction do
      text_message = TextMessage.new(body: "dummy")
      encrypted_messages.each do |msg|
        cipher = text_message.ciphers.build(cipher_body: msg.cipher, iv: msg.iv, encrypted_key: msg.encrypted_key)
        cipher.key_pair = msg.restricted_key_pair
      end

      message.sendable = text_message
      message.save!
    end
  end

  class EncryptedMessage
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attribute :membership_id, :integer
    attribute :key_pair_id, :integer
    attribute :cipher, :string
    attribute :iv, :string
    attribute :encrypted_key, :string

    def public_key
      KeyPair.find(key_pair_id).public_key
    end

    def restricted_key_pair
      Membership.find(membership_id).user.key_pairs.find(key_pair_id)
    end
  end
end
