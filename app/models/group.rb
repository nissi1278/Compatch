class Group < ApplicationRecord
  has_many :participants, dependent: :destroy
  attr_accessor :participant_count

  validates :name, presence: true, length: { maximum: 20 }
  validates :participant_count, presence: true,
            numericality: { only_integer: true, greater_than: 0 },
            on: :create
end
