json.extract! expense, :id, :trip_id, :user_id, :amount, :description, :created_at, :updated_at
json.url expense_url(expense, format: :json)
