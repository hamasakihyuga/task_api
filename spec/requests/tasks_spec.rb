# spec/requests/tasks_spec.rb
require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  # JSONレスポンスをハッシュ/配列に変換する小ヘルパ
  def json
    JSON.parse(response.body)
  end

  describe 'GET /tasks' do
    it 'returns tasks ordered by created_at desc' do
      older = create(:task, title: 'old', created_at: 1.day.ago)
      newer = create(:task, title: 'new', created_at: Time.current)
      get '/tasks'
      titles = json.map { |h| h['title'] }
      expect(titles).to eq(['new', 'old'])
    end
  end

  describe 'GET /tasks/:id' do
    it 'returns a task' do
      task = create(:task)
      get "/tasks/#{task.id}"
      expect(response).to have_http_status(:ok)
      expect(json['id']).to eq(task.id)
    end

    it 'returns 404 when not found' do
      get '/tasks/999999'
      expect(response).to have_http_status(:not_found)
    end

    it 'returns consistent 404 shape' do
      get '/tasks/999999'
      expect(response).to have_http_status(:not_found)
      expect(json).to eq('error' => 'Task not found')
    end
  end

  describe 'POST /tasks' do
    it 'ignores unpermitted params' do
      post '/tasks', params: { task: { title: 'New', admin: true } }, as: :json
      expect(response).to have_http_status(:created)
      expect(json).not_to have_key('admin')
    end

    it 'returns 415 or 400 when Content-Type is not JSON (client mistake)' do
      # わざと JSON では送らない
      post '/tasks', params: 'task=title=abc'
      expect([400, 415]).to include(response.status)
    end

    it 'returns errors array on validation failure' do
      post '/tasks', params: { task: { title: '' } }, as: :json
      expect(response).to have_http_status(422) # :unprocessable_content でも可
      expect(json['errors']).to be_an(Array)
    end

    context 'POST /tasks with due_date' do
      it 'accepts ISO8601 date string' do
        post '/tasks', params: { task: { title: 'D', due_date: '2025-12-31' } }, as: :json
        expect(response).to have_http_status(:created)
        expect(json['due_date']).to eq('2025-12-31')
      end
    end
  end

  describe 'PATCH /tasks/:id' do
    it 'does partial update, keeping other attributes' do
      task = create(:task, title: 'Old', description: 'Keep me', completed: false)
      patch "/tasks/#{task.id}", params: { task: { completed: true } }, as: :json
      expect(response).to have_http_status(:ok)
      expect(json['completed']).to eq(true)
      expect(json['description']).to eq('Keep me') # 不変
    end
  end

  describe 'DELETE /tasks/:id' do
    it 'deletes a task' do
      task = create(:task)
      expect {
        delete "/tasks/#{task.id}"
      }.to change(Task, :count).by(-1)
      expect(response).to have_http_status(:no_content)
      expect(response.body).to be_empty
    end
  end
end
