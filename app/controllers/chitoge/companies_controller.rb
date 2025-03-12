class Chitoge::CompaniesController < ApplicationController
  layout 'admin'
  before_action :set_company, only: %i[ show edit update destroy ]
  before_action :require_admin

  # GET /companies or /companies.json
  def index
    @companies = Company.all
    @departments = Department.all
  end

  # GET /companies/1 or /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies or /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to chitoge_companies_path, notice: "Company was successfully created." }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1 or /companies/1.json
  def update
    @company = Company.find(params[:id])
    if @company.update(company_params)
      redirect_to chitoge_companies_path, notice: 'Company was successfully updated.'
    end
  end

  # DELETE /companies/1 or /companies/1.json
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.json { render json: { message: "Company was successfully deleted." }, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def company_params
      params.require(:company).permit(:name, :code)
    end

    def require_admin
      redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.role === 'admin'
    end
end
