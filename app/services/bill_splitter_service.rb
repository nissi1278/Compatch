class BillSplitterService
  def initialize(total_amount, all_participants, rounding_unit: 500)
    @total_amount = total_amount
    @all_participants = all_participants
    @fixed_participants, @unfixed_participants = all_participants.partition(&:is_manual_fixed)
    @rounding_unit = rounding_unit
  end

  # 入力された合計金額と参加者すべてを受け取り、金額を分割する処理。
  def call
    return default_result if calculation_unnecessary?

    unfixed_base_amount = calculate_base_amount
    build_amount_result(unfixed_base_amount)
  end

  private

  # 計算が不要かチェック
  def calculation_unnecessary?
    @all_participants.empty? || @total_amount.zero?
  end

  # 引数エラー時の戻り値を作成
  def default_result
    {
      payment_rows: [],
      summary: {
        total_amount: @total_amount,
        total_paid: 0,
        remainder: 0
      }
    }
  end

  # 手動で固定された金額を支払う参加者の合計金額を計算する
  def fixed_payments_total
    @fixed_participants.sum { |p| p.payment_amount || 0 }
  end

  # 切り捨て後の支払い金額から割り勘金額を計算
  def calculate_base_amount
    fixed_total_sum_paid = fixed_payments_total
    amount_to_split = @total_amount - fixed_total_sum_paid

    # もし固定額が多すぎてマイナスになったら、未固定の人は0円にする
    amount_to_split = 0 if amount_to_split.negative?

    # .firstでdivmodの商（一人あたりの金額）のみ取得
    calculate_unfixed_split(amount_to_split)
  end

  # 金額未固定の参加者の支払い金額を計算する
  def calculate_unfixed_split(amount)
    return 0 if @unfixed_participants.none?

    unfixed_amount = amount.to_f / @unfixed_participants.count
    unfixed_amount_ceil(unfixed_amount)
  end

  # 金額未固定の参加者の支払い金額を指定された金額で切り上げる(ざっくり割り用)
  def unfixed_amount_ceil(unfixed_amount)
    # 切り上げ桁が1以下の場合、何もせずにそのまま金額を返す(floatにしているので、intで返す)
    return unfixed_amount.to_i if @rounding_unit <= 1

    ratio = (unfixed_amount.to_f / @rounding_unit).ceil

    # 切り上げ後の金額を返す
    (ratio * @rounding_unit).to_i
  end

  # 参加者オブジェクトと支払い金額をまとめたハッシュを配列形式で返す
  def build_payment_list(unfixed_base_amount)
    @all_participants.map do |participant|
      {
        participant: participant,
        amount: participant.is_manual_fixed ? participant.payment_amount : unfixed_base_amount
      }
    end
  end

  # 計算結果を金額ごとし、表示用の行データを作成して返す
  def create_grouped_payments(payment_list)
    grouped_list = payment_list.group_by { |item| item[:amount] }

    # グループ化したハッシュをviewに渡すための配列形式に変換
    rows = grouped_list.map do |amount, items|
      {
        amount: amount,
        participants: items.map { |item| item[:participant] }
      }
    end
    rows.sort_by { |row| row[:amount] }
  end

  # サマリー部分を作成するメソッド
  def calculate_summary(payment_list, unfixed_base_amount)
    total_paid = payment_list.sum { |item| item[:amount] }
    final_remainder = total_paid - @total_amount
    {
      total_amount: @total_amount,
      total_paid: total_paid,
      unfixed_base_amount: unfixed_base_amount,
      remainder: final_remainder
    }
  end

  # 最終的な計算結果を配列のハッシュ形式で返す
  def build_amount_result(unfixed_base_amount)
    payment_list = build_payment_list(unfixed_base_amount)
    {
      payment_rows: create_grouped_payments(payment_list),
      summary: calculate_summary(payment_list, unfixed_base_amount)
    }
  end
end

