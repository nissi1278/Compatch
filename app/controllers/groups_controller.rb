class GroupsController < ApplicationController
  def index
    @group = Group.new
  end

  def create

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
      params.expect(group: [:name, :participant_count])
    end

    def group_show_params
      params.expect(group: [:id])
    end
end
