# Destroy all records
User.destroy_all

# Create users
paul = User.create!(email: "paul@mail.com", password: "123456", nickname:"paul")
delphine = User.create!(email: "delphine@mail.com", password: "123456", nickname:"delphine")
joe = User.create!(email: "joe@mail.com", password: "123456", nickname:"joe")
jane = User.create!(email: "jane@mail.com", password: "123456", nickname:"jane")

# Create flats
flat = Flat.create!(name: "Flat 1", address: "1 rue de la paix", user: paul)

# Create invitations
Invitation.create!(user: delphine, flat: Flat.first, status: "accepted")
Invitation.create!(user: joe, flat: Flat.first, status: "accepted")
Invitation.create!(user: jane, flat: Flat.first, status: "accepted")
