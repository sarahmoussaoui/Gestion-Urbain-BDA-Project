// PAS de "use GestionUrbain;" ici, sinon ça plantera !

db.BON_Voyage.deleteMany({})
db.ligne.deleteMany({})
db["Ligne-Voyages"].deleteMany({})
db.moyen_transport.deleteMany({})
db.navette.deleteMany({})
db.station.deleteMany({})
db.troncon.deleteMany({})
db.voyage.deleteMany({})

print('Toutes les collections ont été vidées avec succès.');
//load("C:\\Users\\HP\\Desktop\\S2I\\S2\\BDA\\TP\\Gestion-Urbain-BDA-Project\\mongodb code\\insection.js")