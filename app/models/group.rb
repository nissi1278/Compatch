class Group < ApplicationRecord
  has_many :participants, dependent: :destroy
  attr_accessor :participant_count

  validates :name, 
            presence: true,
            length: { maximum: 20 }
  validates :participant_count,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 },
            on: :create

  after_initialize :set_default_participant_count

  scope :created_by_session, ->(session_id) { where(session_id: session_id) }

  private

  # 画面初期表示時の参加者人数の初期値を設定
  def set_default_participant_count
    self.participant_count ||= 5
  end
end
