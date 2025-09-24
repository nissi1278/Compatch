class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :calculate]

  def index
    @group = Group.new
  end

  def create
    @group = Group.new(group_create_params)
    @group.session_id = session.id
    if @group.save
      redirect_to calculate_group_path(@group)
    else
      render :index, status: :unprocessable_entity
    end
  end

  def show
    # @group = Group.find()
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def calculate
    if request.patch? && params[:group].present?
      @group.update(group_params)
    end
  
    @participants = @group.participants.order(created_at: :asc)
    total_amount_input = @group.total_amount || 0

    calculated_data = BillSplitter.calculate_split_bill(total_amount_input, @participants)
    @per_person_amount = calculated_data[:per_person_base_amount]
    @remainder_amount = calculated_data[:remainder_amount]
    @grouped_amounts = calculated_data[:grouped_amounts]

    @participant = @group.participants.build 

    respond_to do |format|
      format.html
      format.turbo_stream do
        # calculation-results 部分だけを更新
        render turbo_stream: turbo_stream.replace(
          'calculation-results',
          partial: 'groups/calculation_results',
          locals: {
            per_person_amount: @per_person_amount,
            grouped_amounts: @grouped_amounts,
            num_participants: @participants&.count || 0,
            total_amount: total_amount_input,
            remainder_amount: @remainder_amount,
            error_message: nil
          }
        )
      end
    end
  end

  def save_calculations
  end

  private
    def group_params
      params.expect(group: [:total_amount])
    end

    def group_create_params
      # params.expect(group: [:name, :participant_count])
      params.expect(group: [:name])
    end

    def group_show_params
      params.expect(group: [:id])
    end

    def set_group
      @group = Group.find(params[:id])
    end

end
