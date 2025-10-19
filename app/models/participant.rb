class Participant < ApplicationRecord
  belongs_to :group

  validates :name,
            presence: true,
            length: { maximum: 20 }
  validates :payment_amount,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :is_manual_fixed,
            inclusion: { in: [true, false] }
end
