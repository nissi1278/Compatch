class BillSplitterService
  def initialize(total_amount, all_participants, floor_digits: 3)
    @total_amount = total_amount
    @fixed_participants, @unfixed_participants = all_participants.partition(&:is_manual_fixed)
    @floor_digits = floor_digits
  end

  # 入力された合計金額と参加者すべてを受け取り、金額を分割する処理。
  def call
    if @unfixed_participants.empty? || total_amount_input.nil?
      return {per_person_base_amount: 0, remainder_amount: 0, grouped_amounts: {} }
    end

    amount_floor_value, truncated_value = split_amount_by_digits()
    fixed_total_sum_paid = calculate_fixed_total_sum(fixed_participants)
    
    per_person_base_amount_for_unfixed = 0
    remainder_from_unfixed_split = 0
    
    if unfixed_participants.any?
    end
    
      grouped_amounts = group_by_amount(participant_amounts_data)
      
      total_paid_by_all_calculated = participant_amounts_data.sum { |item| item[:amount] }
      final_remainder = total_amount_input - total_paid_by_all_calculated
      
      {
        per_person_base_amount: per_person_base_amount_for_unfixed,
        remainder_amount: final_remainder,
        grouped_amounts: grouped_amounts
      }
  end
    
  class << self
    # 指定された桁数で金額を切り捨てし、切り捨て後の値と切り捨てた値を計算する
    def split_amount_by_digits
      digits = 10 ** @floor_digits
      truncated_value = @total_amount % digits
      floor_value = @total_amount - truncated_value
      [floor_value, truncated_value]
    end
    
    # 手動で固定された金額を支払う参加者の合計金額を計算する
    def calculate_unfixed_split
      @fixed_participants.sum { |p| p.payment_amount || 0 }
    end

    # 割り勘が必要な残支払い金額を計算する
    def remaining_amount_for_unfixed(amount_floor_value, fixed_total_sum_paid)
      amount_floor_value - fixed_total_sum_paid
    end

    # 金額未固定の参加者の支払い金額を計算する
    def calculate_unfixed(amout, count)
      amount.divmod(count)
    end

    # 各参加者の最終的な支払い金額を決定
    def assign_and_distribute_amounts(all_participants, base_amount, _unfixed_participants, _remainder_count)
      # まず、基本金額を割り当てる
      # amounts_data = all_participants.map do |p|
      #   final_amount = p.is_manual_fixed ? p.payment_amount : base_amount
      #   { participant: p, amount: final_amount }
      #   amounts_data
      # end
    end

    # 最終的な支払い金額に基づいて参加者をグループ化
    def group_by_amount(amounts_data)
      amounts_data.group_by { |item| item[:amount] }
                  .transform_values { |items| items.map { |item| item[:participant] } }
                  .sort_by { |amount, _| amount }
                  .to_h
    end

    def calculate_remainder(total_amount, calculated_total_amount)
      # 最終的な端数を算出
    end
  end
end