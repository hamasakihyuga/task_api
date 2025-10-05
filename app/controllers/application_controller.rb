# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  rescue_from ActionDispatch::Http::Parameters::ParseError do
    render json: { error: 'Bad JSON' }, status: :bad_request
  end

  rescue_from ActionController::BadRequest do
    render json: { error: 'Bad Request' }, status: :bad_request
  end

  # 404はここで一括ハンドルしてOK（文言は課題に合わせてお好みで）
  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'Task not found' }, status: :not_found
  end
end
