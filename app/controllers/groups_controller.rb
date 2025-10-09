class GroupsController < ApplicationController
  before_action :set_group, only: %i[show update destroy]
  include CalculationResponder

  def index
    @group = Group.new
    create_groups = Group.where(session_id: session.id.public_id).order(created_at: :desc)
    @groups = create_groups.page(params[:page]).per(5)
  end

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

  def update
    if @group.update(group_params)
      recalculate_and_respond
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@group) }
      format.html {redirect_to groups_path, notice: 'グループが削除されました。'}
    end
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
      format.html { redirect_to groups_path }

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
