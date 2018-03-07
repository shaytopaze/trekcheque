json.extract! payee, :id, :user_id, :expense_id, :created_at, :updated_at
json.url payee_url(payee, format: :json)
