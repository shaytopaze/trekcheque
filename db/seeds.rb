# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


trip1 = Trip.create!([{
  name: 'Vegas',
  price_per_night: 7000,
  number_of_possible_attendees: 5,
  total_possible_cost_cents: 0,
  total_confirmed_cost_cents: 0,
  start_date: '2018/11/25',
  end_date: '2018/12/04',
  locked: false
  }])

trip2 = Trip.create!([{
  name: 'Hawaii',
  price_per_night: 9000,
  number_of_possible_attendees: 3,
  total_possible_cost_cents: 0,
  total_confirmed_cost_cents: 0,
  start_date: '2018/11/26',
  end_date: '2018/12/04',
  locked: false
  }])

trip3 = Trip.create!([{
  name: 'Azerbaijan',
  price_per_night: 5,
  number_of_possible_attendees: 7,
  total_possible_cost_cents: 0,
  total_confirmed_cost_cents: 0,
  start_date: '2018/11/27',
  end_date: '2018/12/04',
  locked: false
  }])

user1 = User.create!([ {
  name: 'Laura',
  email: 'laura@laura.laura',
  password: '123456',
  password_confirmation: '123456'
  }])

user2 = User.create!([ {
  name: 'Shay',
  email: 'shay@shay.shay',
  password: '123456',
  password_confirmation: '123456'
  }])

user1 = User.create!([ {
  name: 'Steph',
  email: 'steph@steph.steph',
  password: '123456',
  password_confirmation: '123456'
  }])


attendee1 = Attendee.create!([ { user_id: 1, trip_id: 1, balance_cents: 0 }])
attendee2 = Attendee.create!([ { user_id: 1, trip_id: 2, balance_cents: 0 }])
attendee3 = Attendee.create!([ { user_id: 1, trip_id: 3, balance_cents: 0 }])
attendee4 = Attendee.create!([ { user_id: 2, trip_id: 1, balance_cents: 0 }])
attendee5 = Attendee.create!([ { user_id: 2, trip_id: 2, balance_cents: 0 }])
attendee5 = Attendee.create!([ { user_id: 3, trip_id: 1, balance_cents: 0 }])
attendee5 = Attendee.create!([ { user_id: 3, trip_id: 3, balance_cents: 0 }])
attendee5 = Attendee.create!([ { user_id: 3, trip_id: 2, balance_cents: 0 }])

expense1 = Expense.create!([ {
  trip_id: '1',
  user_id: '1',
  amount: '30',
  description: 'Wine'
  }])

  expense2 = Expense.create!([ {
  trip_id: '1',
  user_id: '2',
  amount: '50',
  description: 'Hmaburgers'
  }])

  expense3 = Expense.create!([ {
  trip_id: '1',
  user_id: '1',
  amount: '200',
  description: 'Fries'
  }])

  expense4 = Expense.create!([ {
  trip_id: '2',
  user_id: '1',
  amount: '300',
  description: 'Vodka'
  }])

  expense5 = Expense.create!([ {
  trip_id: '2',
  user_id: '2',
  amount: '50',
  description: 'Teddy bears'
  }])

  expense6 = Expense.create!([ {
  trip_id: '2',
  user_id: '2',
  amount: '200',
  description: 'Skis'
  }])

  expense7 = Expense.create!([ {
  trip_id: '3',
  user_id: '3',
  amount: '30',
  description: 'Tent'
  }])

  expense8 = Expense.create!([ {
  trip_id: '3',
  user_id: '3',
  amount: '50',
  description: 'Juice'
  }])

  expense9 = Expense.create!([ {
  trip_id: '3',
  user_id: '3',
  amount: '200',
  description: 'Mosquito Spray'
  }])

  payee1 = Payee.create!([ { user_id: 1, expense_id: 1 }])
  payee2 = Payee.create!([ { user_id: 2, expense_id: 1 }])
  payee3 = Payee.create!([ { user_id: 3, expense_id: 1 }])
  payee4 = Payee.create!([ { user_id: 1, expense_id: 2 }])
  payee5 = Payee.create!([ { user_id: 2, expense_id: 2 }])
  payee6 = Payee.create!([ { user_id: 1, expense_id: 3 }])
  payee7 = Payee.create!([ { user_id: 1, expense_id: 4 }])
  payee8 = Payee.create!([ { user_id: 1, expense_id: 5 }])
  payee9 = Payee.create!([ { user_id: 2, expense_id: 5 }])
  payee10 = Payee.create!([ { user_id: 2, expense_id: 6 }])
  payee11 = Payee.create!([ { user_id: 3, expense_id: 7 }])
  payee12 = Payee.create!([ { user_id: 3, expense_id: 8 }])
  payee13 = Payee.create!([ { user_id: 3, expense_id: 8 }])
  payee14 = Payee.create!([ { user_id: 2, expense_id: 9 }])