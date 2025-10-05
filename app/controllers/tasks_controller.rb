# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy]
  before_action :ensure_json_request, only: %i[create update]

  # GET /tasks
  def index
    tasks = Task.order(created_at: :desc)
    render json: tasks
  end

  # GET /tasks/:id
  def show
    render json: @task
  end

  # POST /tasks
  def create
    task = Task.new(task_params)
    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/:id
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/:id
  def destroy
    @task.destroy
    head :no_content
  end

  private

  # JSON以外のContent-Typeを415で弾く（create/updateのみ）
  def ensure_json_request
    return if request.content_mime_type&.json? || request.format.json?
    render json: { error: 'Unsupported Media Type' }, status: :unsupported_media_type
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    tp = params[:task]
    unless tp.is_a?(ActionController::Parameters) || tp.is_a?(Hash)
      # Strong Parametersを使えない形なら400
      raise ActionController::BadRequest, 'Invalid parameters'
    end
    params.require(:task).permit(:title, :description, :due_date, :completed)
  end
end
