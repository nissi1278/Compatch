module Groups
  class ParticipantsController < ApplicationController
    before_action :set_group
    include GroupSetup
    include CalculationResponder

    def create
      @participant = @group.participants.create(participant_params)
      recalculate_and_respond_for_create
    end

    def update
      @participant = @group.participants.find(params[:id])
      if @participant.update(participant_params)
        recalculate_and_respond_for_update
      else
        setup_calculation_view_variables
        render 'groups/show', status: :unprocessable_entity
      end
    end

    def destroy
      @participant = @group.participants.find(params[:id])
      @participant.destroy
      recalculate_and_respond_for_destroy
    end

    private

    def set_group
      @group = Group.find(params[:group_id])
    end

    def participant_params
      params.expect(participant: %i[name payment_amount is_manual_fixed])
    end

    # 再計算処理
    def recalculate_result
      @participants = @group.participants.order(created_at: :asc)
      total_amount = @group.total_amount || 0
      BillSplitterService.new(total_amount, @participants).call
    end

    # 更新時の応答 (計算結果のみ更新)
    def recalculate_and_respond_for_update
      result = recalculate_result
      render turbo_stream: [
        turbo_stream.update(
          'calculation_results',
          partial: 'groups/calculation_results',
          locals: { result: result }
        )
      ]
    end

    # rubocop:disable Metrics/MethodLength
    # 追加時の応答 (リストへの追加 + 計算結果の更新)
    def recalculate_and_respond_for_create
      result = recalculate_result
      # 新しい参加者を追加するための空のインスタンスを再度用意
      @new_participant_for_form = @group.participants.build

      render turbo_stream: [
        # 新しい参加者をリストの末尾に追加
        turbo_stream.append(
          'participants_list',
          partial: 'participants/participant',
          locals: { participant: @participant }
        ),
        # 新規追加フォームをリセット
        turbo_stream.replace(
          'new_participant_form',
          partial: 'participants/form',
          locals: { group: @group, participant: @new_participant_for_form }
        ),
        # 計算結果を更新
        turbo_stream.update(
          'calculation_results',
          partial: 'groups/calculation_results',
          locals: { result: result }
        )
      ]
    end
    # rubocop:enable Metrics/MethodLength

    # 削除時の応答 (リストからの削除 + 計算結果の更新)
    def recalculate_and_respond_for_destroy
      result = recalculate_result
      render turbo_stream: [
        # 1. 指定した参加者をリストから削除
        turbo_stream.remove(@participant),
        # 2. 計算結果を更新
        turbo_stream.update('calculation_results', partial: 'groups/calculation_results', locals: { result: result })
      ]
    end
  end
end
