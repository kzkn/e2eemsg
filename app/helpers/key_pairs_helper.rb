module KeyPairsHelper
  def key_pair_data_attributes(key_pair)
    key_pair.attributes.slice("public_key", "encrypted_private_key", "encrypted_private_key_iv")
  end
end
