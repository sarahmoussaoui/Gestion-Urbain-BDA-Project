import tkinter as tk
from tkinter import ttk, messagebox
import oracledb

oracledb.init_oracle_client()  # optional if you later need thick mode
dsn = oracledb.makedsn("localhost", 1521, service_name="xe")
conn = oracledb.connect(user="SQL3", password="BDA_2025", dsn=dsn)

def execute_query(query):
    cursor = conn.cursor()
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    return result

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
        results = execute_query(query)
        text_output.delete("1.0", tk.END)
        for row in results:
            text_output.insert(tk.END, str(row) + "\n")
    except Exception as e:
        messagebox.showerror("Erreur", str(e))

# Interface Tkinter
root = tk.Tk()
root.title("Menu des Requêtes SQL")
root.geometry("900x600")  # Optional: window size

# --- Dropdown in a Frame (for better layout) ---
frame_top = tk.Frame(root)
frame_top.pack(pady=15)

label = tk.Label(frame_top, text="Sélectionnez une requête :", font=("Arial", 12))
label.pack(side=tk.LEFT, padx=10)

combo = ttk.Combobox(frame_top, width=40, font=("Arial", 10), values=[
    "1 - Voyages avec incidents",
    "2 - Lignes avec station principale",
    "3 - Navette la plus active",
    "4 - Stations avec ≥ 2 moyens"
])
combo.current(0)
combo.pack(side=tk.LEFT)

# --- Button ---
tk.Button(root, text="Exécuter", command=run_selected_query, font=("Arial", 11)).pack(pady=10)

# --- Output text box ---
text_output = tk.Text(root, height=20, width=100, font=("Courier", 10))
text_output.pack(padx=10, pady=10, fill=tk.BOTH, expand=True)

root.mainloop()
