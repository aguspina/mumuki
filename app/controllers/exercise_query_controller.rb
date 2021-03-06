class ExerciseQueryController < ApplicationController
  include NestedInExercise

  before_action :authenticate!

  def create
    @query = @exercise.submit_query!(query_params)
    @query.run!
    render json: {result: @query.result, status: @query.status}
  end

  def query_params
    params.permit(:content, :query)
  end
end
