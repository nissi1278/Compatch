FactoryBot.define do
  factory :group do
    # 正常系
    name { 'valid group' }
    participant_count { 1 }
    total_amount { 10_000 }
    sequence(:guest_token) { |n| "#{n}fB2pX9jD1aQvT7hR4mZcWk" }

    # 異常系 trait
    trait :name_too_long do
      name { 'A' * (Group::MAXIMUM_NAME_LENGTH + 1) }
    end

    trait :participant_count_too_large do
      participant_count { Group::MAXIMUM_PARTICIPANT_COUNT + 1 }
    end

    trait :total_amount_too_large do
      total_amount { Group::MAXIMUM_TOTAL_AMOUNT + 1 }
    end

    trait :participant_count_too_small do
      participant_count { Group::MINIMUM_PARTICIPANT_COUNT - 1 }
    end

    trait :total_amount_too_small do
      total_amount { Group::MINIMUM_TOTAL_AMOUNT - 1 }
    end
  end
end
