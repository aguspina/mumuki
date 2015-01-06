class SubmissionsController < ApplicationController
  before_action :authenticate!
  def index
    @submissions = paginated current_user.submissions
  end
end
