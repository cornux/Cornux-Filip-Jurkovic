# Učitavanje libraryja potrebnih za rad koda
import urllib.request
from flask import Flask, request, redirect, jsonify
from werkzeug.utils import secure_filename
import subprocess
import csv

app = Flask(__name__)  # Definiranje Flask servera


isUser = False
@app.route('/<api_key>', methods=['POST', 'GET'])
def hello_world(api_key): # Funkcija za provjeru rada servera
    global isUser

    r = csv.reader(open('users.csv'))  # Otvaranje baze korisnika
    lines = list(r)

    for rows in lines:
        for word in rows:
            if word == api_key:  # Provjeravanje postojanosti klijenta
                lines[lines.index(rows)][1] = str(int(rows[1])-1) #
                writer = csv.writer(open('users.csv', 'w'))       # Aktualizacija broja dopuštenih mjesečnih pristupa
                writer.writerows(lines)                           #
                isUser = True
                break

    if isUser:  # Povratna informacija
        return 'Hello'
    else:
        return 'Invalid key!'


@app.route('/upload/<api_key>', methods=['POST'])  # URL kojim uploadamo sliku
def upload_file(api_key):  # Funkcija za upload
    global isUser

    r = csv.reader(open('users.csv'))  # Otvaranje baze korisnika
    lines = list(r)

    for rows in lines:
        for word in rows:
            if word == api_key:  # Provjeravanje postojanosti klijenta
                lines[lines.index(rows)][1] = str(int(rows[1])-1) #
                writer = csv.writer(open('users.csv', 'w'))       # Aktualizacija broja dopuštenih mjesečnih pristupa
                writer.writerows(lines)                           #
                isUser = True
                break

    if isUser:
        file = request.files['file']  # Formatiranje slike
        print(file)
        file.save('api.jpg')  # Spremanje slike
        subprocess.call("python3 scan.py", shell=True)  # Pozivanje skripte za daljnju obradu
        f = open("response.txt", "r")                             #
        resp = jsonify({'message': 'File successfully uploaded'}) # Povratna informacija - upload uspio
        resp.status_code = 201                                    #
        return f.read()
    else:
        return 'Invalid API_key or None!'



@app.route('/availableCalls/<api_key>', methods=['POST', 'GET']) # URL za provjeru mjesečnog stanja
def availableCalls(api_key): # Funkcija za broj dostupnih mjesečnih poziva
    r = csv.reader(open('users.csv'))  # Otvaranje baze korisnika
    lines = list(r)

    for rows in lines:
        for word in rows:
            if word == api_key: # Provjeravanje postojanosti klijenta
                availableCalls = lines[lines.index(rows)][1]      # Broj dostupnih poziva ovaj mjesec
                limit = lines[lines.index(rows)][2]               #
                lines[lines.index(rows)][1] = str(int(rows[1])+1) # Aktualizacija broja dopuštenih mjesečnih pristupa
                writer = csv.writer(open('users.csv', 'w'))       #
                writer.writerows(lines)
                available = [int(availableCalls), int(limit)]
                return jsonify(available)  # Printanje trenutnog stanja i mjesečnog limita


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000) # Inicijalizacija Flask servera
