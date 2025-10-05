class GroupsController < ApplicationController
  before_action :set_group, only: %i[show update destroy]
  include CalculationResponder

  def index
    @group = Group.new
  end

  # 割り勘の「表示」・「計算」を担当。
  def show
    @participants = @group.participants.order(created_at: :asc)
    # 新しい参加者を追加するための空のインスタンス
    @participant = @group.participants.build
    total_amount_input = @group.total_amount || 0

    @result = BillSplitterService.new(total_amount_input, @participants).call
  end

  def create
    @group = Group.new(group_create_params)
    @group.participant_count = params[:group][:participant_count].to_i
    @group.session_id = session.id

    if @group.save
      create_initial_participants
      redirect_to group_path(@group), notice: 'グループが作成されました。'
    else
      render :index, status: :unprocessable_entity
    end
  end

  # Groupの情報（合計金額など）の「更新」を担当
  def update
    if @group.update(group_params)
      recalculate_and_respond
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy
    redirect_to root_path, notice: 'グループが削除されました。'
  end

  private

  def group_params
    params.expect(group: [:total_amount])
  end

  def group_create_params
    params.expect(group: [:name])
  end

  def set_group
    @group = Group.find(params[:id])
  end

  # updateアクションの再計算処理
  def recalculate_and_respond
    @participants = @group.participants.order(created_at: :asc)
    total_amount_input = @group.total_amount || 0
    result = BillSplitterService.new(total_amount_input, @participants).call

    respond_to do |format|
      format.html { redirect_to group_path(@group) }

      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          'calculation-results',
          partial: 'groups/calculation_results',
          locals: { result: result }
        )
      end
    end
  end

  def create_initial_participants
    return if @group.participant_count.zero?

    @group.participant_count.times do |i|
      @group.participants.create(name: "参加者 #{i + 1}")
    end
  end
end
