json.extract! leave_request, :id, :employee_id, :from, :to, :type, :status, :approved_at, :created_at, :updated_at
json.url leave_request_url(leave_request, format: :json)
