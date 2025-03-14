require 'faker'

Bookmark.destroy_all

50.times do
  Bookmark.create!(
    title: Faker::Book.title,
    url: Faker::Internet.url
  )
end

puts "SUCCESS: 50 bookmark's records has been created."
