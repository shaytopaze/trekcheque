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
  start_date: '2018/11/28',
  end_date: '2018/12/04',
  locked: false
  }])

trip2 = Trip.create!([{
  name: 'Hawaii',
  price_per_night: 9000,
  number_of_possible_attendees: 3,
  start_date: '2018/11/28',
  end_date: '2018/12/04',
  locked: false
  }])

trip3 = Trip.create!([{
  name: 'Azerbaijan',
  price_per_night: 5,
  number_of_possible_attendees: 7,
  start_date: '2018/11/28',
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


attendee1 = Attendee.create!([ { user_id: 1, trip_id: 1 }])
attendee2 = Attendee.create!([ { user_id: 1, trip_id: 2 }])
attendee3 = Attendee.create!([ { user_id: 1, trip_id: 3 }])
attendee4 = Attendee.create!([ { user_id: 2, trip_id: 1 }])
attendee5 = Attendee.create!([ { user_id: 2, trip_id: 2 }])
attendee5 = Attendee.create!([ { user_id: 3, trip_id: 1 }])
attendee5 = Attendee.create!([ { user_id: 3, trip_id: 3 }])
attendee5 = Attendee.create!([ { user_id: 3, trip_id: 2 }])