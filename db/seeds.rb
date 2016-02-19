# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Inserting default security users
users = {
  admin: {
    name: 'Admin',
    email: 'admin@flitter.com',
    password: 'password',
    password_confirmation: 'password',
    role: :admin
  },

  administrator: {
    name: 'Administrator',
    email: 'administrator@flitter.com',
    password: 'password',
    password_confirmation: 'password',
    role: :admin
  }
}

users.each do |user, data|
  user = User.new(data)

  unless User.where(email: user.email).exists?
    user.skip_confirmation!
    user.save!
  end
end
