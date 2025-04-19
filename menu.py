import tkinter as tk
from tkinter import ttk, messagebox
import oracledb

# --- Oracle connection setup ---
oracledb.init_oracle_client()
dsn = oracledb.makedsn("localhost", 1521, service_name="xe")
conn = oracledb.connect(user="SQL3", password="BDA_2025", dsn=dsn)


def execute_query(query):
    cursor = conn.cursor()
    cursor.execute(query)
    columns = [desc[0] for desc in cursor.description]
    result = cursor.fetchall()
    cursor.close()
    return columns, result


def run_selected_query():
    selected = combo.get()
    query = None

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
        columns, results = execute_query(query)
        update_table(columns, results)
    except Exception as e:
        messagebox.showerror("Erreur", str(e))


def update_table(columns, data):
    for widget in table_frame.winfo_children():
        widget.destroy()

    tree = ttk.Treeview(table_frame, columns=columns, show='headings', height=15)
    for col in columns:
        tree.heading(col, text=col)
        tree.column(col, anchor=tk.CENTER, width=150)

    for row in data:
        tree.insert('', tk.END, values=row)

    tree.pack(fill='both', expand=True)


def fade_in_label(widget, text, i=0):
    if i <= len(text):
        widget.config(text=text[:i])
        root.after(50, fade_in_label, widget, text, i + 1)


# --- Main Tkinter setup ---
root = tk.Tk()
root.title("Application SQL Moderne")
root.geometry("900x700")
root.configure(bg="#f7f9fb")

# Optional: Add icon
try:
    root.iconbitmap("icon.ico")
except:
    pass

# Styles
style = ttk.Style()
style.theme_use("clam")  # default theme

# Logo
try:
    logo_img = tk.PhotoImage(file="logo.png")
    logo_label = tk.Label(root, image=logo_img, bg="#f7f9fb")
    logo_label.pack(pady=10)
except:
    pass

# Fancy title animation
fade_label = ttk.Label(root, text="", font=("Segoe UI", 14, "bold"))
fade_label.pack(pady=10)
fade_in_label(fade_label, "Bienvenue dans l'application Gestion Urbain!")

# Combobox
tk.Label(root, text="Sélectionnez une requête :", font=("Segoe UI", 11), bg="#f7f9fb").pack(pady=(10, 0))

combo = ttk.Combobox(root, width=40, values=[
    "1 - Voyages avec incidents",
    "2 - Lignes avec station principale",
    "3 - Navette la plus active",
    "4 - Stations avec ≥ 2 moyens"
])
combo.pack(pady=5)
combo.current(0)

# Execute button
ttk.Button(root, text="Exécuter", command=run_selected_query).pack(pady=10)

# Results table
table_frame = ttk.Frame(root)
table_frame.pack(padx=10, pady=20, fill='both', expand=True)

root.mainloop()
