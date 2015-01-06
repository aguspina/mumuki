class Submission < ActiveRecord::Base
  include TestRunning
  include WithStatus

  belongs_to :exercise
  belongs_to :submitter, class_name: 'User'

  validates_presence_of :exercise, :submitter

  after_create :update_submissions_count!
  after_commit :schedule_test_run!, on: :create

  delegate :language, :title, to: :exercise

  def result_preview
    result.truncate(100) unless passed?
  end

  private

  def update_submissions_count!
    self.class.connection.execute(
        "update exercises
         set submissions_count = submissions_count + 1
        where id = #{exercise.id}")
    exercise.reload
  end
end



