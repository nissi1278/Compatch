module GroupSetup
  extend ActiveSupport::Concern
  # このメソッドは、@groupが既に定義されていることを前提とします。
  def setup_calculation_view_variables
    @participants = @group.participants.order(created_at: :asc)
    # 新しい参加者を追加するための空のインスタンス
    @participant = @group.participants.build
    total_amount_input = @group.total_amount || 0

    @result = BillSplitterService.new(total_amount_input, @participants).call
  end
end