class TasksController < ApplicationController
  before_action :set_task, only: [:show]
  before_action :set_users, only: [:new, :edit]
  before_action :set_current_user_task, olny: [:edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
    unless @task
      redirect_to :tasks, notice: t('.task_access_deny') 
    end
  end

  def create
    @task = Task.new(task_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: t('.task_success') }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    def set_users
      @users = User.all
      #.map{ |user| [ user.full_name, user.id ] }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :description)
    end

    def set_current_user_task
      @task = current_user.tasks.find_by(id: params[:id])
    end 

end
