# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#admin
User.create!(name: "Admin",
email: "admin@admin.com",
password: "admin",
password_confirmation: "admin",
admin: true)

#users
9.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@mail.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password)  
end

#pages
9.times do |n|
  page_name  = Faker::Educator.course
  description = "Opis"
  Page.create!(name:  page_name,
               description: description)  
end
#microposts
 users = User.order(:created_at).take(5)
 pages = Page.order(:created_at).take(5)
 10.times do 
   	content = Faker::Lorem.sentence(5)
	pages.each{|page|
	users.each { |user| user.microposts.create!(content: content, page_id: page.id) }
    }
 end

#relationship
users = User.all
pages = Page.all
following = pages
followers = users[3..7]
followers.each{|user|
following.each { |followed| user.follow(followed) }
}