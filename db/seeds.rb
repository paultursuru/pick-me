# Destroy all records
User.destroy_all

# Create users
paul = User.create!(email: "paul@mail.com", password: "123456")
delphine = User.create!(email: "delphine@mail.com", password: "123456")


# Create flats
flat = Flat.create!(name: "Flat 1", address: "1 rue de la paix", user: paul)

# Create invitations
Invitation.create!(user: delphine, flat: Flat.first)

puts "Created #{User.count} users"
puts "Flat created by #{flat.user.email}"
puts "Invited users: #{flat.invited_users.map{|user| user.email}.join(', ')}"
