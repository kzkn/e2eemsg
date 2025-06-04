class Cipher < ApplicationRecord
  belongs_to :key_pair
  belongs_to :encryptable, polymorphic: true
end
