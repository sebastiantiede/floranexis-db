#!/bin/bash

# Überprüfe, ob die Anzahl der übergebenen Parameter korrekt ist
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <relative_path_to_folder> <relative_output_filename>"
    exit 1
fi

# Extrahiere die Parameter
relative_folder_path="$1"
relative_output_file="$2"

# Ermittle das absolute Verzeichnis des Ordners, in dem das Skript ausgeführt wird
script_dir="$( pwd )"

# Konstruiere den absoluten Pfad zum Ordner mit den JSON-Dateien
absolute_folder_path="$script_dir/$relative_folder_path"

# Konstruiere den absoluten Pfad zur Ausgabedatei
absolute_output_file="$script_dir/$relative_output_file"

# Überprüfe, ob der angegebene Ordner existiert, andernfalls beende das Skript
if [ ! -d "$absolute_folder_path" ]; then
    echo "Error: The specified folder '$absolute_folder_path' does not exist."
    exit 1
fi

# Wechsle zum angegebenen Ordner
cd "$absolute_folder_path" || exit

# Lösche den Inhalt der Ausgabedatei, falls sie existiert
if [ -f "$absolute_output_file" ]; then
    > "$absolute_output_file"
fi

# Schleife durch alle JSON-Dateien im Ordner
for file in *.json; do
    # Überprüfe, ob es sich um eine Datei handelt
    if [ -f "$file" ]; then
        # Füge das JSON-Objekt aus der Datei zur Ausgabedatei hinzu
        jq -c . "$file" >> "$absolute_output_file"
        # Füge ein Komma hinzu, um die JSON-Objekte im Array zu trennen, außer für die letzte Datei
    fi
done

# tr -d '\n\t' < "$absolute_output_file" > temp_file
# mv temp_file "$absolute_output_file"

echo "All JSON files have been merged into '$absolute_output_file'."
