module Chitoge


class Chitoge::DepartmentsController < BaseChitogeController
  layout 'admin'
  before_action :set_department, only: %i[ show edit update destroy ]
  # before_action :require_admin

  # GET /departments or /departments.json
  def index
    @departments = Department.all
  end

  # GET /departments/1 or /departments/1.json
  def show
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments or /departments.json
  def create
    @department = Department.new(department_params)

    respond_to do |format|
      if @department.save
        format.html { redirect_to chitoge_companies_path(@department), notice: "Department was successfully created." }
        format.json { render :show, status: :created, location: @department }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departments/1 or /departments/1.json
  def update
    @department = Department.find(params[:id])
    if @department.update(department_params)
      redirect_to chitoge_companies_path, notice: 'Department was successfully updated.'
    end
  end

  # DELETE /departments/1 or /departments/1.json
  def destroy
    @department = Department.find(params[:id])
    @department.destroy

    respond_to do |format|
      format.json { render json: { message: "Department was successfully deleted." }, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def department_params
      params.require(:department).permit(:name, :company_id)
    end

    def require_admin
      redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.role === 'admin'
    end
end
end
