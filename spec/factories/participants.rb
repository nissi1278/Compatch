FactoryBot.define do
  factory :participant do
    association :group

    name { 'valid participant' }
    payment_amount { 0 }
    is_manual_fixed { false }

    # 異常系trait
    trait :name_too_long do
      name { 'a' * (Participant::MAXIMUM_NAME_LENGTH + 1) }
    end
    trait :payment_amount_too_small do
      payment_amount { Participant::MINIMUM_PAYMENT_AMOUNT - 1 }
    end
    trait :is_manual_fixed_other_value do
      is_manual_fixed { nil }
    end
  end
end
