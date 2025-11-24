class Group < ApplicationRecord
  has_many :participants, dependent: :destroy
  attr_accessor :participant_count

  INIT_PARTICIPANT_COUNT = 5
  MAXIMUM_NAME_LENGTH = 20
  MINIMUM_PARTICIPANT_COUNT = 0
  MAXIMUM_PARTICIPANT_COUNT = 30
  MINIMUM_TOTAL_AMOUNT = 0
  MAXIMUM_TOTAL_AMOUNT = 1_000_000

  validates :name,
            presence: true,
            length: { maximum: MAXIMUM_NAME_LENGTH }
  validates :participant_count,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: MINIMUM_PARTICIPANT_COUNT,
                            less_than_or_equal_to: MAXIMUM_PARTICIPANT_COUNT },
            on: :create
  validates :total_amount,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: MINIMUM_TOTAL_AMOUNT,
                            less_than_or_equal_to: MAXIMUM_TOTAL_AMOUNT }

  has_secure_token :share_token

  after_initialize :set_default_participant_count
  scope :created_by_session, ->(token) { where(guest_token: token) }

  private

  # 画面初期表示時の参加者人数の初期値を設定
  def set_default_participant_count
    self.participant_count ||= INIT_PARTICIPANT_COUNT
  end
end
