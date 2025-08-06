class GroupsController < ApplicationController
  def index
    @group = Group.new
  end

  def create
    @group = Group.new(group_create_params)
    if @group.save
      redirect_to calculate_group_participants(@group)
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

  private
    def group_create_params
      # params.expect(group: [:name, :participant_count])
      params.expect(group: [:name])
    end

    def group_show_params
      params.expect(group: [:id])
    end
end
