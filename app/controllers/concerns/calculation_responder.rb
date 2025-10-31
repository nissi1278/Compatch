module CalculationResponder
  extend ActiveSupport::Concern

  private

  # 複数のコントローラで共有したい、再計算と応答のロジック
  def recalculate_and_respond
    @participants = @group.participants.order(created_at: :asc)
    total_amount = @group.total_amount || 0
    result = BillSplitterService.new(total_amount, @participants).call

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          'calculation-results',
          partial: 'groups/calculation_results',
          locals: { result: result }
        )
      end
    end
  end
end
