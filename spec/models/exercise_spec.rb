require 'spec_helper'

describe Exercise do
  let(:exercise) { create(:exercise) }
  let(:user) { create(:user) }

  describe '#submitted_by?' do
    context 'when user did a submission' do
      before { exercise.submissions.create(submitter: user) }
      it { expect(exercise.submitted_by? user).to be true }
    end
    context 'when user did no submission' do
      it { expect(exercise.submitted_by? user).to be false }
    end
  end

  describe '#solved_by?' do
    context 'when user did no submission' do
      it { expect(exercise.solved_by? user).to be false }
    end
    context 'when user did a successful submission' do
      before { exercise.submissions.create(submitter: user, status: :passed) }

      it { expect(exercise.solved_by? user).to be true }
    end
    context 'when user did a pending submission' do
      before { exercise.submissions.create(submitter: user) }

      it { expect(exercise.solved_by? user).to be false }
    end
    context 'when user did both successful and failed submissions' do
      before do
        exercise.submissions.create(submitter: user)
        exercise.submissions.create(submitter: user, status: :passed)
      end

      it { expect(exercise.solved_by? user).to be true }
    end
  end

  describe '#destroy' do
    context 'when there are no submissions' do
      it { exercise.destroy! }
    end

    context 'when there are submissions' do
      before { create(:submission, exercise: exercise) }
      it { expect { exercise.destroy! }.to raise_error }
    end

  end

  describe '#default_content_for' do
    context 'when user has a single submission for the exercise' do
      let!(:submission) { exercise.submissions.create!(submitter: user, content: 'foo') }

      it { expect(exercise.default_content_for(user)).to eq submission.content }
    end

    context 'when user has no submissions for the exercise' do
      it { expect(exercise.default_content_for(user)).to eq '' }
    end


    context 'when user has multiple submission for the exercise' do
      let!(:submissions) { [exercise.submissions.create!(submitter: user, content: 'foo'),
                            exercise.submissions.create!(submitter: user, content: 'bar')] }

      it { expect(exercise.default_content_for(user)).to eq submissions.last.content }
    end
  end


  describe '#by_tag' do
    let!(:tagged_exercise) { create(:exercise, tag_list: 'foo') }
    let!(:untagged_exercise) { create(:exercise) }

    it { expect(Exercise.by_tag('foo')).to include(tagged_exercise) }
    it { expect(Exercise.by_tag('foo')).to_not include(untagged_exercise) }

    it { expect(Exercise.by_tag('bar')).to_not include(tagged_exercise, untagged_exercise) }

    it { expect(Exercise.by_tag(nil)).to include(tagged_exercise, untagged_exercise) }
  end
end
