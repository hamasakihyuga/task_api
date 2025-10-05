require 'rails_helper'


RSpec.describe Task, type: :model do
  it 'rejects title with only spaces' do
    t = build(:task, title: '   ')
    expect(t).to be_invalid
  end

  it 'is invalid without a title' do
    t = build(:task, title: nil)
    expect(t).to be_invalid
    expect(t.errors[:title]).to include("can't be blank")
  end

it 'has default completed=false from DB' do
    t = Task.create!(title: 'db default')
    expect(t.read_attribute(:completed)).to eq(false) # DBからの実値を確認
  end
end
