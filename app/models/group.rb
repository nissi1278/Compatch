class Group < ApplicationRecord
  has_many :participants, dependent: :destroy
end
