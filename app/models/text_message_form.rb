class TextMessageForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :encrypted_messages

  def encrypted_messages_attributes=(attrs)
    self.encrypted_messages = attrs.values.map { EncryptedMessage.new(_1) }
  end

  class EncryptedMessage
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attribute :membership_id, :integer
    attribute :key_pair_id, :integer
    attribute :cipher, :string

    def public_key
      KeyPair.find(key_pair_id).public_key
    end
  end
end
