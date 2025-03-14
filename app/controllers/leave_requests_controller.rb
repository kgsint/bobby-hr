class LeaveRequestsController < ApplicationController
  layout 'admin'
  before_action :set_leave_request, only: [:approve, :decline]
  before_action :admin_only, only: [:index, :update]

  # GET /leave_requests or /leave_requests.json
  def index
    @leave_requests = LeaveRequest.all
  end

  # GET /leave_requests/1 or /leave_requests/1.json
  def show
  end

  # GET /leave_requests/new
  def new
    @leave_request = current_user.leave_requests.build
  end
  # GET /leave_requests/1/edit
  def edit
  end

  # POST /leave_requests or /leave_requests.json
  def create
    @leave_request = current_user.leave_requests.build(leave_request_params)
    if @leave_request.save
      redirect_to root_path, notice: "Leave request submitted successfully."
    else
      render :new, alert: "Failed to submit leave request."
    end
  end

  # PATCH/PUT /leave_requests/1 or /leave_requests/1.json
  def update
    case params[:status]
    when "approved"
      @leave_request.update(status: "approved", approved_at: Time.current)
      redirect_to leave_requests_path, notice: "Leave request approved."
    when "declined"
      @leave_request.update(status: "declined")
      redirect_to leave_requests_path, notice: "Leave request declined."
    else
      redirect_to leave_requests_path, alert: "Invalid action."
    end
  end

  # PATCH /leave_requests/:id/approve
  def approve
    @leave_request.update(status: "approved", approved_at: Time.current)
    redirect_to leave_requests_path, notice: "Leave request approved."
  end

  # PATCH /leave_requests/:id/decline
  def decline
    @leave_request.update(status: "declined")
    redirect_to leave_requests_path, notice: "Leave request declined."
  end

  # DELETE /leave_requests/1 or /leave_requests/1.json
  def destroy
    @leave_request.destroy!

    respond_to do |format|
      format.html { redirect_to leave_requests_url, notice: "Leave request was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_leave_request
      @leave_request = LeaveRequest.find(params[:id])
    end

    def leave_request_params
      params.require(:leave_request).permit(:from, :to, :leave_type, :status)
    end

    def admin_only
      redirect_to root_path, alert: "Access denied." unless current_user.role === "company_admin"
    end
end
