class GuidesController < ApplicationController

  before_action :authenticate!

  def new
    @guide = Guide.new
  end

  def create
    @guide = Guide.new(guide_params.merge(author: current_user))
    @guide.imports.build
    if @guide.save
      redirect_to @guide, notice: t(:guide_created)
    else
      render :new
    end
  end

  def show
    @guide = Guide.find(params[:id])
  end

  def index
    @guides = paginated current_user.guides
  end

  private

  def guide_params
    params.require(:guide).permit(:github_repository, :name)
  end
end
