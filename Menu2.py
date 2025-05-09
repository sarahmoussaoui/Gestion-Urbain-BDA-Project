import tkinter as tk
from tkinter import ttk, messagebox
from pymongo import MongoClient
from bson.json_util import dumps
import datetime
from PIL import Image, ImageTk

# Connexion à MongoDB
client = MongoClient("mongodb://localhost:27017/")
db = client["GestionUrbain"]

# Fonctions des requêtes
def requete1():
    results = db.voyage.find({
        "date": {
            "$gte": datetime.datetime(2025, 1, 1),
            "$lt": datetime.datetime(2025, 1, 2)
        }
    })
    return list(results)

def requete2():
    pipeline = [
        {"$match": {"observation": {"$nin": ["Panne", "Panne mineure"]}}},
        {"$lookup": {
            "from": "navette",
            "localField": "navette_id",
            "foreignField": "_id",
            "as": "navette_info"}},
        {"$unwind": "$navette_info"},
        {"$lookup": {
            "from": "ligne",
            "localField": "navette_info.ligne_id",
            "foreignField": "_id",
            "as": "ligne_info"}},
        {"$unwind": "$ligne_info"},
        {"$project": {
            "_id": 1,
            "numLigne": "$ligne_info._id",
            "date": 1,
            "heure": "$heureDebut",
            "sens": 1,
            "navette_id": 1,
            "moyen_transport": "$ligne_info.moyen_transport_id"}}
    ]
    results = db.voyage.aggregate(pipeline)
    return list(results)

def requete3():
    results = db["Ligne-Voyages"].find().sort("totalVoyages", -1)
    return list(results)

# Nouvelle requête 4 : Augmenter de 100 voyageurs pour les voyages métro avant le 15 janvier 2025
def requete4():
    try:
        lignesMetro = [ligne["_id"] for ligne in db.ligne.find({"moyen_transport_id": "MET"})]
        navettesMetro = [navette["_id"] for navette in db.navette.find({"ligne_id": {"$in": lignesMetro}})]
        
        # Appliquer l'update
        db.voyage.update_many(
            {
                "navette_id": {"$in": navettesMetro},
                "date": {"$lt": datetime.datetime(2025, 1, 15)}
            },
            {"$inc": {"nbVoyageurs": 100}}
        )

        # Récupérer les documents mis à jour pour affichage
        resultats = db.voyage.find(
            {
                "navette_id": {"$in": navettesMetro},
                "date": {"$lt": datetime.datetime(2025, 1, 15)}
            },
            {
                "_id": 1,
                "navette_id": 1,
                "date": 1,
                "nbVoyageurs": 1
            }
        )

        return list(resultats)

    except Exception as e:
        return f"Erreur dans la requête 4: {str(e)}"

# Nouvelle requête 5 : MapReduce pour les voyages par ligne
# Nouvelle requête 5 : MapReduce pour les voyages par ligne
def requete5():
    try:
        # Construire un dictionnaire des navettes avec leur ligne associée
        navettesDict = {}
        cursor = db.navette.find()
        for doc in cursor:
            navettesDict[doc["_id"]] = doc.get("ligne", "inconnu")
        
        # Enregistrer le dictionnaire navettesDict dans une collection temporaire
        db.navette_mapreduce_dict.delete_many({})  # Effacer les anciennes données de la collection
        db.navette_mapreduce_dict.insert_one({"navettesDict": navettesDict})

        mapFunction = """
        var navettesDict = db.navette_mapreduce_dict.findOne().navettesDict;
        function() {
            var ligne = navettesDict[this.navette_id] || "inconnu";
            emit(ligne, 1);
        }
        """
        
        reduceFunction = """
        function(key, values) {
            return Array.sum(values);
        }
        """

        # Lancer MapReduce
        db.voyage.mapReduce(
            mapFunction,
            reduceFunction,
            {
                "out": {"replace": "Ligne_Voyages"}
            }
        )

        # Récupérer les résultats et les trier par nombre de voyages
        results = db.Ligne_Voyages.find().sort({"value": -1})
        return list(results)

    except Exception as e:
        return f"Erreur dans la requête 5: {str(e)}"





# Nouvelle requête 6 : Navettes avec le plus grand nombre de voyages
def requete6():
    try:
        # Obtenir le nombre maximal de voyages par navette
        maxCount = list(db.voyage.aggregate([
            {
                "$group": {
                    "_id": "$navette_id",
                    "nbVoyages": {"$sum": 1}
                }
            },
            {
                "$sort": {"nbVoyages": -1}
            },
            {
                "$limit": 1
            }
        ]))[0]["nbVoyages"]

        # Récupérer les navettes ayant ce nombre maximal de voyages
        topNavettes = list(db.voyage.aggregate([
            {
                "$group": {
                    "_id": "$navette_id",
                    "nbVoyages": {"$sum": 1}
                }
            },
            {
                "$match": {"nbVoyages": maxCount}
            },
            {
                "$lookup": {
                    "from": "navette",
                    "localField": "_id",
                    "foreignField": "_id",
                    "as": "navette"
                }
            },
            {"$unwind": "$navette"},
            {
                "$lookup": {
                    "from": "ligne",
                    "localField": "navette.ligne_id",
                    "foreignField": "_id",
                    "as": "ligne"
                }
            },
            {"$unwind": "$ligne"},
            {
                "$project": {
                    "_id": 0,
                    "navette_id": "$_id",
                    "marque": "$navette.marque",
                    "nbVoyages": 1,
                    "moyen_transport": "$ligne.moyen_transport_id"
                }
            }
        ]))
        
        return topNavettes
    except Exception as e:
        return f"Erreur dans la requête 6: {str(e)}"
# Nouvelle requête 7 : Nombre de jours où le seuil de voyageurs a été dépassé pour chaque moyen de transport
def requete7():
    try:
        S = 100  # Seuil de voyageurs

        # Exécution de l'agrégation
        results = db.voyage.aggregate([
            # 1. Join navette
            {
                "$lookup": {
                    "from": "navette",
                    "localField": "navette_id",
                    "foreignField": "_id",
                    "as": "navette"
                }
            },
            { "$unwind": "$navette" },

            # 2. Join ligne
            {
                "$lookup": {
                    "from": "ligne",
                    "localField": "navette.ligne_id",
                    "foreignField": "_id",
                    "as": "ligne"
                }
            },
            { "$unwind": "$ligne" },

            # 3. Group by moyen_transport_id + date
            {
                "$group": {
                    "_id": {
                        "moyen": "$ligne.moyen_transport_id",
                        "date": { "$dateToString": { "format": "%Y-%m-%d", "date": "$date" } }
                    },
                    "totalVoyageurs": { "$sum": "$nbVoyageurs" }
                }
            },

            # 4. Marquer si le seuil est dépassé
            {
                "$project": {
                    "moyen": "$_id.moyen",
                    "date": "$_id.date",
                    "depasseSeuil": { "$gt": ["$totalVoyageurs", S] }
                }
            },

            # 5. Regrouper par moyen de transport pour compter les jours total vs jours > S
            {
                "$group": {
                    "_id": "$moyen",
                    "joursTotal": { "$sum": 1 },
                    "joursSeuilDepasse": {
                        "$sum": {
                            "$cond": ["$depasseSeuil", 1, 0]
                        }
                    }
                }
            },

            # 6. Garder uniquement ceux où le seuil est toujours dépassé
            {
                "$match": {
                    "$expr": { "$eq": ["$joursTotal", "$joursSeuilDepasse"] }
                }
            },

            # 7. Affichage propre
            {
                "$project": {
                    "_id": 0,
                    "moyen_transport": "$_id",
                    "joursTotal": 1
                }
            }
        ])

        return list(results)
    except Exception as e:
        return f"Erreur dans la requête 7: {str(e)}"


# Dictionnaire des requêtes
requete_dict = {
    "Voyages du 01/01/2025": requete1,
    "Voyages sans panne": requete2,
    "Ligne-Voyages": requete3,
    "Augmenter 100 voyageurs pour métro": requete4,
    "Voyages par ligne (MapReduce)": requete5,
    "Navettes avec plus de voyages": requete6,
    "Moyen Transport avec Max nombre de voyageurs": requete7 
}

# Interface Tkinter
def executer_requete():
    nom_requete = choix_requete.get()
    if nom_requete in requete_dict:
        try:
            # Récupération des résultats sous forme de liste
            resultat = requete_dict[nom_requete]()
            afficher_resultats(resultat)
        except Exception as e:
            messagebox.showerror("Erreur", str(e))

# Fonction pour afficher les résultats dans un tableau
def afficher_resultats(resultat):
    # Vider le tableau existant
    for row in treeview.get_children():
        treeview.delete(row)

    # Si des résultats existent, on les ajoute
    if resultat:
        # Créer des colonnes dynamiquement selon les clés des résultats
        if isinstance(resultat, list):
            columns = list(resultat[0].keys()) if isinstance(resultat[0], dict) else ["_id", "value"]
        else:
            columns = ["Message"]

        treeview["columns"] = columns
        treeview["show"] = "headings"
        
        # Ajouter les entêtes de colonnes
        for col in columns:
            treeview.heading(col, text=col)
            treeview.column(col, width=100)

        # Ajouter les données ligne par ligne
        if isinstance(resultat, list):
            for doc in resultat:
                treeview.insert("", "end", values=[doc[col] for col in columns])
        else:
            treeview.insert("", "end", values=[resultat])

# Fonction d'animation du texte (affichage progressif)
def fade_in_label(label, text, delay=0.1, i=0):
    if i < len(text):
        label.config(text=text[:i+1])
        label.update_idletasks()  # Met à jour l'affichage
        label.after(int(delay * 1000), fade_in_label, label, text, delay, i + 1)

fenetre = tk.Tk()
fenetre.title("Menu MongoDB - Transport Urbain")
fenetre.geometry("900x700")
fenetre.configure(bg="#f7f9fb")

# Optional: Add icon
try:
    fenetre.iconbitmap("images/icon.ico")
except:
    pass

# Styles
style = ttk.Style()
style.theme_use("clam")  # default theme

# Logo (resized with Pillow)
try:
    original_logo = Image.open("images/logo.png")
    resized_logo = original_logo.resize((120, 120))  # Set your desired size (width, height)
    logo_img = ImageTk.PhotoImage(resized_logo)
    logo_label = tk.Label(fenetre, image=logo_img, bg="#f7f9fb")
    logo_label.image = logo_img  # Keep a reference to avoid garbage collection
    logo_label.pack(pady=10)
except Exception as e:
    print("Erreur chargement logo:", e)

# Combobox
tk.Label(fenetre, text="Sélectionnez une requête :", font=("Segoe UI", 11), bg="#f7f9fb").pack(pady=(10, 0))

choix_requete = ttk.Combobox(fenetre, values=list(requete_dict.keys()), state="readonly")
choix_requete.pack(pady=5)
choix_requete.current(0)

# Bouton d'exécution
btn_exec = tk.Button(fenetre, text="Exécuter", command=executer_requete)
btn_exec.pack(pady=5)

# Zone de tableau pour afficher les résultats
treeview = ttk.Treeview(fenetre)
treeview.pack(padx=10, pady=10, fill=tk.BOTH, expand=True)

# Affichage du texte d'introduction avec animation
fade_label = ttk.Label(fenetre, text="", font=("Segoe UI", 14, "bold"))
fade_label.pack(pady=10)

# Animation du texte "Bienvenue dans l'application Gestion Urbain!"
fade_in_label(fade_label, "Bienvenue dans l'application Gestion Urbain!")

fenetre.mainloop()
