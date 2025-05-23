import tkinter as tk
from tkinter import ttk, messagebox
import oracledb
from PIL import Image, ImageTk

oracledb.init_oracle_client()
dsn = oracledb.makedsn("localhost", 1521, service_name="orclpdb")  # ou "orcl"
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

    if selected == "Voyages avec incidents":
        query = "SELECT * FROM vw_voyages_incidents"
    elif selected == "Lignes avec station principale":
        query = "SELECT * FROM vw_lignes_station_principale"
    elif selected == "Navette la plus active":
        query = "SELECT * FROM vw_navette_plus_active"
    elif selected == "Stations avec ≥ 2 moyens":
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
root.title("Application Gestion Urbain")
root.geometry("900x700")
root.configure(bg="#f7f9fb")

# Optional: Add icon
try:
    root.iconbitmap("images/icon.ico")
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
    logo_label = tk.Label(root, image=logo_img, bg="#f7f9fb")
    logo_label.image = logo_img  # Keep a reference to avoid garbage collection
    logo_label.pack(pady=10)
except Exception as e:
    print("Erreur chargement logo:", e)


# Fancy title animation
fade_label = ttk.Label(root, text="", font=("Segoe UI", 14, "bold"))
fade_label.pack(pady=10)
fade_in_label(fade_label, "Bienvenue dans l'application Gestion Urbain!")

# Combobox
tk.Label(root, text="Sélectionnez une requête :", font=("Segoe UI", 11), bg="#f7f9fb").pack(pady=(10, 0))

combo = ttk.Combobox(root, width=40, values=[
    "Voyages avec incidents",
    "Lignes avec station principale",
    "Navette la plus active",
    "Stations avec ≥ 2 moyens"
])
combo.pack(pady=5)
combo.current(0)

# Execute button
ttk.Button(root, text="Exécuter", command=run_selected_query).pack(pady=10)

# Results table
table_frame = ttk.Frame(root)
table_frame.pack(padx=10, pady=20, fill='both', expand=True)

root.mainloop()
