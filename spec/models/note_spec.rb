require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project, owner: user) }

  it 'is valid with a user, project, and message' do
    note = Note.new(
      message: 'My important note.',
      project: project,
      user: user
    )
    expect(note).to be_valid
  end

  it { is_expected.to validate_presence_of :message }

  # FactoryBot使用
  it 'delegates name to the user who created it' do
    user = FactoryBot.create(:user, first_name: 'Fake', last_name: 'User')
    note = Note.new(user: user)
    expect(note.user_name).to eq 'Fake User'
  end

  # モックとスタブ使用
  it 'delegates name to the user who created it' do
    # 検証機能なし
    # user = double('user', name: 'Fake User')
    user = instance_double('User', name: 'Fake User')
    note = Note.new
    allow(note).to receive(:user).and_return(user)
    expect(note.user_name).to eq 'Fake User'
  end

  describe 'search message for a term' do
    let!(:note1) do
      create(:note, project: project, user: user, message: 'This is the first note.')
    end
    let!(:note2) do
      create(:note, project: project, user: user, message: 'This is the second note.')
    end
    let!(:note3) do
      create(:note, project: project, user: user, message: 'First, preheat the oven.')
    end

    context 'when a match is found' do
      it 'returns notes that match the search term' do
        expect(Note.search('first')).to include(note1, note3)
      end
    end

    context 'when no match is found' do
      it 'returns an empty collection when no results are found' do
        expect(Note.search('message')).to be_empty
        expect(Note.count).to eq 3
      end
    end
  end
end
