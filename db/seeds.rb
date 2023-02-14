# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

lodging_8 = Lodging.create(name: "La Chevêche", summary: "4 à 8 personnes", price_night: 240)
lodging_16 = Lodging.create(name: "La Hulotte", summary: "9 à 16 personnes", price_night: 480)
lodging_25 = Lodging.create(name: "Le Grand-Duc", summary: "17 à 25 personnes", price_night: 750, party_hall_availability: true)

room_romarin = Room.create(name: "Romarin", level: 0, code: "ROM", description: "lit double + lit superposé")
room_balsamine = Room.create(name: "Balsamine", level: 0, code: "BAL", description: "lit double + lit superposé")
room_lavande = Room.create(name: "Lavande", level: 1, code: "LAV", description: "2 lits simples")
room_melisse = Room.create(name: "Mélisse", level: 1, code: "MEL", description: "3 lits simples")
room_capucine = Room.create(name: "Capucine", level: 1, code: "CAP", description: "3 lits simples")
room_sarriette = Room.create(name: "Sarriette", level: 2, code: "SAR", description: "lit double + lit simple")
room_origan = Room.create(name: "Origan", level: 2, code: "ORI", description: "lit double + lit superposé")
room_laurier = Room.create(name: "Laurier (mezzanine)", level: 2, code: "MEZ", description: "2 lits simples")

LodgingRoom.create(lodging: lodging_8, room: room_romarin)
LodgingRoom.create(lodging: lodging_8, room: room_balsamine)

LodgingRoom.create(lodging: lodging_16, room: room_lavande)
LodgingRoom.create(lodging: lodging_16, room: room_melisse)
LodgingRoom.create(lodging: lodging_16, room: room_capucine)
LodgingRoom.create(lodging: lodging_16, room: room_sarriette)
LodgingRoom.create(lodging: lodging_16, room: room_origan)

LodgingRoom.create(lodging: lodging_25, room: room_romarin)
LodgingRoom.create(lodging: lodging_25, room: room_balsamine)
LodgingRoom.create(lodging: lodging_25, room: room_lavande)
LodgingRoom.create(lodging: lodging_25, room: room_melisse)
LodgingRoom.create(lodging: lodging_25, room: room_capucine)
LodgingRoom.create(lodging: lodging_25, room: room_sarriette)
LodgingRoom.create(lodging: lodging_25, room: room_origan)
