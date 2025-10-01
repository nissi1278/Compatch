class BillSplitterService
  def initialize(total_amount, all_participants, floor_digits: 3)
    @total_amount = total_amount
    @all_participants = all_participants
    @fixed_participants, @unfixed_participants = all_participants.partition(&:is_manual_fixed)
    @floor_digits = floor_digits
  end

  # 入力された合計金額と参加者すべてを受け取り、金額を分割する処理。
  def call
    if @unfixed_participants.empty? || @total_amount.zero?
      return { per_person_base_amount: 0, remainder_amount: 0, grouped_amounts: {} }
    end

    amount_floor_value, truncated_value = split_amount_by_digits
    fixed_total_sum_paid = fixed_payments_total

    amount_to_split = amount_floor_value - fixed_total_sum_paid
    base_amount, unfixed_truncated_value = calculate_unfixed_split(amount_to_split)
  end

  private

  # 指定された桁数で金額を切り捨てし、切り捨て後の値と切り捨てた値を計算する
  def split_amount_by_digits
    digits = 10 ** @floor_digits
    truncated_value = @total_amount % digits
    floor_value = @total_amount - truncated_value
    [floor_value, truncated_value]
  end

  # 手動で固定された金額を支払う参加者の合計金額を計算する
  def fixed_payments_total
    @fixed_participants.sum { |p| p.payment_amount || 0 }
  end

  # 金額未固定の参加者の支払い金額を計算する
  def calculate_unfixed_split(amount)
    return [0, 0] if @unfixed_participants.none?

    amount.divmod(@unfixed_participants.count)
  end
end
