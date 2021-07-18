require 'rails_helper'

RSpec.describe Note, type: :model do
  before do
    @project = FactoryBot.create(:project)
  end
  it 'is valid with a user, project, and message' do
    note = Note.new(
      message: 'My important note.',
      project: @project,
      user: @project.owner
    )
    expect(note).to be_valid
  end

  it 'is invalid without a message' do
    note = FactoryBot.build(:note, message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe 'search message for a term' do
    before do
      user = FactoryBot.create(:user)
      @note1 = FactoryBot.create(:note, message: 'This is the first note.', user: user)
      @note2 = FactoryBot.create(:note, message: 'This is the second note.', user: user)
      @note3 = FactoryBot.create(:note, message: 'First, preheat the oven.', user: user)
    end

    context 'when a match is found' do
      it 'returns notes that match the search term' do
        expect(Note.search('first')).to include(@note1, @note3)
      end
    end

    context 'when no match is found' do
      it 'returns an empty collection when no results are found' do
        expect(Note.search('message')).to be_empty
      end
    end
  end
end
