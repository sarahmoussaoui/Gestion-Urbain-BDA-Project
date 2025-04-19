import tkinter as tk
from tkinter import ttk, messagebox
import oracledb

# Oracle connection
oracledb.init_oracle_client()
dsn = oracledb.makedsn("localhost", 1521, service_name="xe")
conn = oracledb.connect(user="SQL3", password="BDA_2025", dsn=dsn)

# App window
root = tk.Tk()
root.title("Requêtes SQL - Application Moderne")
root.geometry("950x600")
root.configure(bg="#f0f2f5")

# Apply a modern theme
style = ttk.Style()
style.theme_use("clam")  # Try "vista", "alt", "default" depending on your OS

# Styling
style.configure("TLabel", font=("Segoe UI", 11), background="#f0f2f5")
style.configure("TButton", font=("Segoe UI", 10), padding=6)
style.configure("TCombobox", padding=4)
style.configure("Treeview", font=("Segoe UI", 10), rowheight=25)
style.configure("Treeview.Heading", font=("Segoe UI Semibold", 10))

# --- Layout: Top Frame with Label + Combobox ---
frame_top = ttk.Frame(root)
frame_top.pack(pady=20)

ttk.Label(frame_top, text="Sélectionnez une requête :").pack(side=tk.LEFT, padx=10)

combo = ttk.Combobox(frame_top, width=45, values=[
    "1 - Voyages avec incidents",
    "2 - Lignes avec station principale",
    "3 - Navette la plus active",
    "4 - Stations avec ≥ 2 moyens"
])
combo.current(0)
combo.pack(side=tk.LEFT)

# --- Execute Button ---
ttk.Button(root, text="Exécuter la requête", command=lambda: run_selected_query()).pack(pady=10)

# --- Treeview for results ---
tree_frame = ttk.Frame(root)
tree_frame.pack(fill=tk.BOTH, expand=True, padx=20, pady=10)

columns = []
tree = ttk.Treeview(tree_frame, columns=columns, show="headings")
tree.pack(fill=tk.BOTH, expand=True)

# Scrollbar
scrollbar = ttk.Scrollbar(tree_frame, orient="vertical", command=tree.yview)
tree.configure(yscroll=scrollbar.set)
scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

# --- Execute Query ---
def execute_query(query):
    cursor = conn.cursor()
    cursor.execute(query)
    cols = [desc[0] for desc in cursor.description]
    results = cursor.fetchall()
    cursor.close()
    return cols, results

# --- Display in Treeview ---
def display_results(columns, data):
    # Clear previous
    for col in tree["columns"]:
        tree.heading(col, text="")
    tree.delete(*tree.get_children())
    tree["columns"] = columns
    for col in columns:
        tree.heading(col, text=col)
        tree.column(col, anchor="center", stretch=True)
    for row in data:
        tree.insert("", "end", values=row)

# --- Query logic ---
def run_selected_query():
    selected = combo.get()
    if selected == "1 - Voyages avec incidents":
        query = "SELECT * FROM vw_voyages_incidents"
    elif selected == "2 - Lignes avec station principale":
        query = "SELECT * FROM vw_lignes_station_principale"
    elif selected == "3 - Navette la plus active":
        query = "SELECT * FROM vw_navette_plus_active"
    elif selected == "4 - Stations avec ≥ 2 moyens":
        query = "SELECT * FROM vw_station_principale_moyens"
    else:
        messagebox.showwarning("Avertissement", "Choix invalide.")
        return

    try:
        cols, results = execute_query(query)
        if results:
            display_results(cols, results)
        else:
            messagebox.showinfo("Info", "Aucun résultat trouvé.")
    except Exception as e:
        messagebox.showerror("Erreur", str(e))

root.mainloop()
