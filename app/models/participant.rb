class Participant < ApplicationRecord
  belongs_to :group

  MAXIMUM_NAME_LENGTH = 20
  MINIMUM_PAYMENT_AMOUNT = 0

  validates :name,
            presence: true,
            length: { maximum: MAXIMUM_NAME_LENGTH }
  validates :payment_amount,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: MINIMUM_PAYMENT_AMOUNT }
  validates :is_manual_fixed,
            inclusion: { in: [true, false] }
end
