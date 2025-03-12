class Chitoge::AttendancesController < ApplicationController
  layout "admin"
  before_action :set_employee, only: [:index, :check_in, :check_out]

  def index
    if params[:employee_id]
      @month = params[:month].present? ? Date.parse(params[:month]) : Date.today.beginning_of_month
      all_days = (@month.beginning_of_month..@month.end_of_month).to_a
  
      # Pagination logic
      per_page = 15
      page = (params[:page] || 1).to_i
      total_pages = (all_days.count.to_f / per_page).ceil
  
      @days = all_days.slice((page - 1) * per_page, per_page) || []
      @attendances = @employee.attendances.where(date: @month.beginning_of_month..@month.end_of_month)
      @current_page = page
      @total_pages = total_pages 

      render "chitoge/employees/attendances/index"
    else
      @employees = Employee.all
      view_type = params[:view].present? ? params[:view] : "weekly"
      per_page = 15
      page = (params[:page] || 1).to_i
    
      begin
        @date = params[:date].present? ? Date.parse(params[:date]) : Date.today
      rescue ArgumentError
        @date = Date.today
      end

      begin
        @month = params[:month].present? ? Date.parse(params[:month]) : Date.today.beginning_of_month
      rescue ArgumentError
        @month = Date.today.beginning_of_month
      end

      begin
        @week_start = params[:week].present? ? Date.parse(params[:week]).beginning_of_week : Date.today.beginning_of_week
      rescue ArgumentError
        @week_start = Date.today.beginning_of_week
      end
    
      @week_end = @week_start.end_of_week
    
      case view_type
      when "daily"
        @attendances = fetch_attendances_for_date(@date)
      when "monthly"
        @attendances = fetch_attendances_for_month(@month)
      else
        @attendances = fetch_attendances_for_week(@week_start, @week_end)
      end
    
      total_pages = (@attendances.count.to_f / per_page).ceil
      @attendances = @attendances.offset((page - 1) * per_page).limit(per_page)
    
      @current_page = page
      @total_pages = total_pages
    
      render "chitoge/attendances/index"
    end
  end

  def check_in
    current_date = Date.current
    existing_attendance = Attendance.find_by(employee_id: current_employee.id, date: current_date)

    if existing_attendance
      flash[:alert] = "You've already checked in today."
    else
      Attendance.create!(
        employee_id: current_employee.id,
        date: Date.current,
        checkin_time: Time.current,
        status: "checked_in"
      )
      flash[:notice] = "Checked in at #{Time.current.strftime('%H:%M')}"
    end

    redirect_back(fallback_location: root_path)
  end


  def check_out
    attendance = Attendance.find_by(employee_id: current_employee.id, date: Date.today)

    if attendance.nil?
      flash[:alert] = "You must check in before checking out."
    elsif attendance.checkout_time.present?
      flash[:alert] = "You've already checked out."
    else
      checkin_time = attendance.checkin_time
      checkout_time = Time.current
      total_hours = ((checkout_time - checkin_time) / 3600).round(2)


      attendance.update!(
        checkout_time: Time.current,
        hours_worked: total_hours
      )
      flash[:notice] = "Checked out at #{checkout_time.strftime('%H:%M')}. Total hours worked: #{total_hours} hours."
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def set_employee
    @employee = Employee.find_by(id: params[:employee_id]) if params[:employee_id].present?
  end

  def fetch_attendances_for_date(date)
    Attendance.includes(:employee).where(date: date).order(date: :desc)
  end
  
  def fetch_attendances_for_month(month)
    Attendance.includes(:employee).where(date: month.beginning_of_month..month.end_of_month).order(date: :desc)
  end
  
  def fetch_attendances_for_week(week_start, week_end)
    Attendance.includes(:employee).where(date: week_start..week_end).order(date: :desc)
  end
end
