module BillSplitter
  extend ActiveSupport::Concern
  # 入力された合計金額と参加者すべてを受け取り、金額を分割する処理。
  def self.calculate_split_bill(total_amount_input, all_participants)
    return { per_person_base_amount: 0, remainder_amount: 0, grouped_amounts: {} } 
    if all_participants.empty? || total_amount_input.nil?

    fixed_participants = all_participants.select(&:is_manual_fixed)
    unfixed_participants = all_participants.reject(&:is_manual_fixed)

    fixed_total_sum_paid = calculate_fixed_total_sum(fixed_participants)
    remaining_amount_for_unfixed = total_amount_input - fixed_total_sum_paid

    per_person_base_amount_for_unfixed = 0
    remainder_from_unfixed_split = 0

    if unfixed_participants.count > 0
      per_person_base_amount_for_unfixed = remaining_amount_for_unfixed / unfixed_participants.count
      remainder_from_unfixed_split = remaining_amount_for_unfixed % unfixed_participants.count
    end

    participant_amounts_data = assign_and_distribute_amounts(
      all_participants,
      per_person_base_amount_for_unfixed,
      unfixed_participants,
      remainder_from_unfixed_split
    )

    grouped_amounts = group_by_amount(participant_amounts_data)

    total_paid_by_all_calculated = participant_amounts_data.sum { |item| item[:amount] }
    final_remainder = total_amount_input - total_paid_by_all_calculated

    {
      per_person_base_amount: per_person_base_amount_for_unfixed,
      remainder_amount: final_remainder,
      grouped_amounts: grouped_amounts,
    }
  end

  private
    # 手動で固定された金額を支払う参加者の合計金額を計算する
    def self.calculate_fixed_total_sum(participants)
      fixed_participants = participants.select(&:is_manual_fixed)
      fixed_participants.sum { |p| p.payment_amount || 0 }
    end

  # 各参加者の最終的な支払い金額を決定し、端数を分配する
  def self.assign_and_distribute_amounts(all_participants, base_amount, unfixed_participants, remainder_count)
    # まず、基本金額を割り当てる
    amounts_data = all_participants.map do |p|
      final_amount = p.is_manual_fixed ? p.payment_amount : base_amount
      { participant: p, amount: final_amount }
    end

    # 次に、端数を分配する
    # if remainder_count > 0
    #   unfixed_participants.first(remainder_count).each do |p|
    #     item_index = amounts_data.index { |item| item[:participant] == p }
    #     amounts_data[item_index][:amount] += 1
    #   end
    # end
    amounts_data
  end

  # 最終的な支払い金額に基づいて参加者をグループ化
  def self.group_by_amount(amounts_data)
    amounts_data.group_by { |item| item[:amount] }
                .transform_values { |items| items.map { |item| item[:participant] } }
                .sort_by { |amount, _| amount }
                .to_h
  end

  # 最終的な端数を算出
  def self.calculate_remainder(total_amount, calculated_total_amount)
  end
end