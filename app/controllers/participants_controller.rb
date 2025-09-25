class ParticipantsController < ApplicationController
  before_action :set_group
  before_action :set_participant, only: [:update, :destroy]

  def create
    @participant = @group.participants.new(name: '参加者')

    respond_to do |format|
      if @participant.save
        format.turbo_stream
        format.html { redirect_to calculate_group_path(@group), notice: '参加者を追加しました。' }
      else
      end
    end
  end

  def destroy
    @participant = @group.participants.find(params[:id])

    respond_to do |format|
      if @participant.destroy
        format.turbo_stream
        format.html { redirect_to calculate_group_path(@group), notice: '参加者を削除しました。' }
      else
      end
    end
  end

  def update
    if params[:participant].present?
      @participant.is_manual_fixed = params[:participant][:is_manual_fixed] == 'true'
      @participant.payment_amount = params[:participant][:payment_amount].presence
    end

    if @participant.save
      all_participants = @group.participants.order(created_at: :asc)
      total_amount_input = @group.total_amount || 0

      # BillSplitter モジュールのメソッドを呼び出す
      calculated_data = BillSplitter.calculate_split_bill(total_amount_input, all_participants)
      @per_person_amount = calculated_data[:per_person_base_amount]
      @remainder_amount = calculated_data[:remainder_amount]
      @grouped_amounts = calculated_data[:grouped_amounts]

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(@participant),
            partial: 'participants/participant',
            locals: { participant: @participant, per_person_amount: @per_person_amount }
          ) +
          turbo_stream.update(
            'calculation-results',
            partial: 'groups/calculation_results',
            locals: {
              per_person_amount: @per_person_amount,
              grouped_amounts: @grouped_amounts,
              num_participants: all_participants.count,
              total_amount: total_amount_input,
              remainder_amount: @remainder_amount,
              error_message: nil
            }
          )
        end
        format.html { redirect_to calculate_group_path(@group), notice: '参加者の金額を調整しました。' }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :unprocessable_entity }
        format.html { redirect_to calculate_group_path(@group), alert: '参加者の更新に失敗しました。' }
      end
    end
  end

  private
  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_participant
    @participant = @group.participants.find(params[:id])
  end

  def participant_params
    params.expect(participant: [:name, :is_manual_fixed, :payment_amount])
  end
end
