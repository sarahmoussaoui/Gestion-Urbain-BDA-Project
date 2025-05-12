//Afficher tous les voyages effectués en date du 01-01-2025 (préciser les détails de chaque
//voyage)

db.voyage.find({
    date: {
      $gte: new Date("2025-01-01T00:00:00Z"), // superieur a 01-01-2025 minuit
      $lt: new Date("2025-01-02T00:00:00Z")   // inferieur a 02-01-2025 a minuit 
    }
  }).pretty();

/*************************** Requete 2********************************* */
/*Dans une collection BON-Voyage, récupérer tous les voyages (numéro, numLigne, date,
heure, sens) n’ayant enregistré aucun problème, préciser le moyen de transport, le numéro
de la navette associés au voyage.*/


db.voyage.aggregate([
    {
      $match: {
        observation: { $nin: ["Panne", "Panne mineure"] }
      }
    },
    {
      $lookup: {
        from: "navette",
        localField: "navette_id",
        foreignField: "_id",
        as: "navette_info"
      }
    },
    { $unwind: "$navette_info" },
    {
      $lookup: {
        from: "ligne",
        localField: "navette_info.ligne_id",
        foreignField: "_id",
        as: "ligne_info"
      }
    },
    { $unwind: "$ligne_info" },
    {
      $project: {
        _id: 1, // numéro du voyage
        numLigne: "$ligne_info._id",
        date: "$date",
        heure: "$heureDebut",
        sens: "$sens",
        navette_id: "$navette_id",
        moyen_transport: "$ligne_info.moyen_transport_id"
      }
    },
    {
      $merge: {
        into: "BON_Voyage",
        whenMatched: "replace",
        whenNotMatched: "insert"
      }
    }
  ]);

  /**********************************requete3*************************** */
  /*Récupérer dans une nouvelle collection Ligne-Voyages, les numéros de lignes et le nombre
total de voyages effectués (par ligne). La collection devra être ordonnée par ordre
décroissant du nombre de voyages. Afficher le contenu de la collection.*/
db.voyage.aggregate([
  {
    $lookup: {
      from: "navette",
      localField: "navette_id",
      foreignField: "_id",
      as: "navette"
    }
  },
  {
    $unwind: "$navette"
  },
  {
    $group: {
      _id: "$navette.ligne_id",  // Regroupe par ligne_id
      nombre_voyages: { $sum: 1 } // Comptabilise les voyages
    }
  },
  {
    $sort: { nombre_voyages: -1 }  // Trie par nombre de voyages décroissant
  },
  {
    $out: "Ligne-Voyages"  // Sauvegarde le résultat dans une nouvelle collection
  }
]);

// Afficher le contenu de la nouvelle collection
db["Ligne-Voyages"].find().pretty();


/**************************************requete4********************/
/*Augmenter de 100, le nombre de voyageurs sur tous les voyages effectués par métro avant
la date du 15 janvier 2025.*/
// Étape 1 : Trouver les lignes de métro
// Étape 1 : Récupérer les lignes de métro
const lignesCursor = db.ligne.find({ moyen_transport_id: "MET" });
let lignesMetro = [];
while (lignesCursor.hasNext()) {
  lignesMetro.push(lignesCursor.next()._id);
}

// Étape 2 : Récupérer les navettes associées à ces lignes
const navettesCursor = db.navette.find({ ligne_id: { $in: lignesMetro } });
let navettesMetro = [];
while (navettesCursor.hasNext()) {
  navettesMetro.push(navettesCursor.next()._id);
}

// Étape 3 : Mettre à jour les voyages
db.voyage.updateMany(
  {
    navette_id: { $in: navettesMetro },
    date: { $lt: new Date("2025-01-15") }
  },
  { $inc: { nbVoyageurs: 100 } }
);
// pour verifier 
 db.voyage.find(
  {
      navette_id: { $in: navettesMetro },
      date: { $lt: new Date("2025-01-15") }
    }
   ).pretty();
  
/****************requete 5************************/

// Dictionnaire navette → ligne
var navettesDict = {};
db.navette.find().forEach(function(doc) {
    navettesDict[doc._id] = doc.ligne_id;
});

// Fonction map
var mapFunction = function() {
    var ligne = navettesDict[this.navette_id] || "inconnu";
    emit(ligne, 1);
};

// Fonction reduce
var reduceFunction = function(key, values) {
    return Array.sum(values);
};

// Exécution MapReduce
db.voyage.mapReduce(
    mapFunction,
    reduceFunction,
    {
        out: { replace: "Ligne_Voyages" },
        scope: { navettesDict: navettesDict }
    }
);

// Affichage des résultats triés
print("Résultats triés:");
var results = db.Ligne_Voyages.find().sort({ value: -1 }).toArray();
results.forEach(function(doc) {
    print("Ligne " + doc._id + ": " + doc.value + " voyages");
});



/***************************requete6**************************************************/
// Étape 1 à 4 dans un pipeline
let maxCount = db.voyage.aggregate([
  {
    $group: {
      _id: "$navette_id",
      nbVoyages: { $sum: 1 }
    }
  },
  {
    $sort: { nbVoyages: -1 }
  },
  {
    $limit: 1
  }
]).toArray()[0].nbVoyages;

// Étape 5 : Trouver toutes les navettes ayant ce nombre de voyages
let topNavettes = db.voyage.aggregate([
  {
    $group: {
      _id: "$navette_id",
      nbVoyages: { $sum: 1 }
    }
  },
  {
    $match: { nbVoyages: maxCount }
  },
  {
    $lookup: {
      from: "navette",
      localField: "_id",
      foreignField: "_id",
      as: "navette"
    }
  },
  { $unwind: "$navette" },
  {
    $lookup: {
      from: "ligne",
      localField: "navette.ligne_id",
      foreignField: "_id",
      as: "ligne"
    }
  },
  { $unwind: "$ligne" },
  {
    $project: {
      _id: 0,
      navette_id: "$_id",
      marque: "$navette.marque",
      nbVoyages: 1,
      moyen_transport: "$ligne.moyen_transport_id"
    }
  }
]);
topNavettes.forEach(printjson);





/**************************requete 6******************************************************/


const S = 100;

db.voyage.aggregate([
  // 1. Join navette
  {
    $lookup: {
      from: "navette",
      localField: "navette_id",
      foreignField: "_id",
      as: "navette"
    }
  },
  { $unwind: "$navette" },

  // 2. Join ligne
  {
    $lookup: {
      from: "ligne",
      localField: "navette.ligne_id",
      foreignField: "_id",
      as: "ligne"
    }
  },
  { $unwind: "$ligne" },

  // 3. Group by moyen_transport_id + date
  {
    $group: {
      _id: {
        moyen: "$ligne.moyen_transport_id",
        date: { $dateToString: { format: "%Y-%m-%d", date: "$date" } }
      },
      totalVoyageurs: { $sum: "$nbVoyageurs" }
    }
  },

  // 4. Marquer si le seuil est dépassé
  {
    $project: {
      moyen: "$_id.moyen",
      date: "$_id.date",
      depasseSeuil: { $gt: ["$totalVoyageurs", S] }
    }
  },

  // 5. Regrouper par moyen de transport pour compter les jours total vs jours > S
  {
    $group: {
      _id: "$moyen",
      joursTotal: { $sum: 1 },
      joursSeuilDepasse: {
        $sum: {
          $cond: ["$depasseSeuil", 1, 0]
        }
      }
    }
  },

  // 6. Garder uniquement ceux où le seuil est toujours dépassé
  {
    $match: {
      $expr: { $eq: ["$joursTotal", "$joursSeuilDepasse"] }
    }
  },

  // 7. Affichage propre
  {
    $project: {
      _id: 0,
      moyen_transport: "$_id",
      joursTotal: 1
    }
  }
]);



  
 