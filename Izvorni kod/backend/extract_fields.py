# Učitavanje paketa potrebnih za rad koda
import os
import json
import boto3
import io
from io import BytesIO
import sys
from cv2 import cv2
from PIL import Image, ImageDraw, ImageOps
from image_processing import denoising
import time
import numpy as np

# Definiranje imena firmi koje prepoznajemo na računu
# TODO: Prebacivanje imena firmi u CSV datoteku
imena_firmi = ['Tomo', 'Pik', 'Nerimar', 'C.A.K', 'Mrkac', 'Metro', 'Ilirija', 'Welbi', 'Trgovina Krk', 'Ivan Katunar', 'Velpro', 'Teri']

# Puna imena prije prepoznatih firmi koja su nam potrebna za fiskalnu kasu
# TODO: Prebacivanje imena firmi u CSV datoteku
imena_firmi_cijela = ['Mesnica Tomo d.o.o.', 'PIK VRBOVEC - MESNA INDUSTRIJA, d.d.', 'NERIMAR d.o.o.', 'C.A.K. d.o.o', 'MRKAČ - obrt', 'Metro Cash & Carry d.o.o', 'PEKARSKI OBRT "ILIRIJA KRK"', 'WELBI d.o.o', 'TRGOVINA KRK d.d.', 'OPG Ivan Katunar', 'VELPRO-CENTAR d.o.o.', 'Teri Trgovina d.o.o']

# Ključna riječ za pronalazak broja računa na otpremnici
# TODO: Prebacivanje markera u CSV datoteku
broj_racuna = ['Racun', 'Otpremnica', 'Racun-otpremnica', 'Racun-dostvanica', 'Fiskalni br. racuna', 'Racun-otpremnica br.', 'Racun/otpremnica br.', 'Otpremnica-racun br.', 'Broj racuna']

ime_firme = ' ' # Varijabla u koju spremamo ime firme na otpremnici
racun = 0

def initialize(): # Funkcija u kojoj pozivamo Amazon Textract za OCR i obradu slike

    # Pozivanje i uspostavljanje veze sa AWS servisom
    client = boto3.client(
        service_name='textract',
        region_name='eu-west-1',
    )

    # Otvaranje prije obrađene slike 
    # Pretvaranje slike u niz bajtova kako bi se mogla poslati putem Interneta
    with open(file_name, 'rb') as file:
            img_test = file.read()
            bytes_test = bytearray(img_test)

    # varijabla koja sadrži odgovor AWS servisa u JSON formatu
    response = client.analyze_document(
        Document={'Bytes': bytes_test}, FeatureTypes=['TABLES']) # Pod FeatureTypes označujemo što želimo pronaći na slici, u našem slučaju tražimo tablice podataka

    # Spremanje odgovora u tekstnu datoteku
    with open("file.json", "w") as file_data:
        json.dump(response, file_data, indent=4, sort_keys=True) # Formatiranje JSON-a radi lakšeg čitanja
    
    ################################ Filtriranje JSON datoteke #######################################

    blocks = response['Blocks'] #Varijabla koja sadrži blok iz JSON datoteke

    blocks_map = {} # Niz u koji spremamo veze između različitih blokova
    table_blocks = [] # Blokovi koji imaju tip podataka tablice

    # Prolazimo kroz sve blokove te spremamo one koji imaju tip tablice
    for block in blocks:
        blocks_map[block['Id']] = block

        if block['BlockType'] == 'TABLE':
            table_blocks.append(block) # Ddodavanje tablice u niz za daljnju obradu
    for index, table in enumerate(table_blocks):
        get_rows_columns_map(table, blocks_map) # Pozivamo funkciju kako bismo odredili broj mapu redova i stupaca tablice

    find_vendor_name(blocks) # Pozivamo funkciju koja pronalazi ime prodavača
    find_table(blocks) # Pozivamo funkciju koja pronalazi koordinate tablice na slici

    #################################################################################################
    return None

def get_rows_columns_map(table_result, blocks_map):
    rows = {}
    for relationship in table_result['Relationships']:
        if relationship['Type'] == 'CHILD':
            for child_id in relationship['Ids']:
                cell = blocks_map[child_id]
                if cell['BlockType'] == 'CELL':
                    row_index = cell['RowIndex']
                    column_index = cell['ColumnIndex']
                    if row_index not in rows:
                        rows[row_index] = {}

                    tekst = get_text(cell, blocks_map)
                    rows[row_index][column_index] = tekst
    return rows


def get_text(result, blocks_map):
    text = ''
    if 'Relationships' in result:
        for relationship in result['Relationships']:
            if relationship['Type'] == 'CHILD':
                for child_id in relationship['Ids']:
                    word = blocks_map[child_id]
                    if word['BlockType'] == 'WORD':
                        for item, value in word.items():
                            if item == 'Geometry':
                                for key, coordinates in value.items():
                                    if key == 'BoundingBox':
                                        draw_rectangle(coordinates)

    return text

rects = []

def draw_rectangle(koordinate):
    global file_name
    global rects
    global blank

    height, width, channels = blank.shape

    x = int(koordinate['Left']*width)
    y = int(koordinate['Top']*height)

    x1 = int((koordinate['Left']*width) + (koordinate['Width']*width))
    y1 = int((koordinate['Top']*height) + (koordinate['Height']*height))

    rect = (x, y, width, height)
    rects.append(rect)
    cv2.rectangle(blank, (x, y), (x1, y1), (0, 0, 0), cv2.FILLED)
    return None

def find_vendor_name(blocks):
    global ime_firme
    for block in blocks: #Traženje imena firme
            if block['BlockType'] == 'LINE':
                for item, value in block.items():
                    if item == 'Text':
                        for ime in imena_firmi:
                            if ime.lower() in value.lower():
                                for firma in imena_firmi_cijela:
                                    if ime.lower() in firma.lower():
                                        print(firma)
                                        ime_firme = firma
    return ime_firme

def find_table(blocks):
    koordinate = {}
    x=0
    for block in blocks: #Traženje tablice (koordinate)
            if block['BlockType'] == 'TABLE':
                for item, value in block.items():
                    if item == 'Geometry':
                        for key, coordinates in value.items():
                            if key == 'BoundingBox':
                                koordinate.update(coordinates)
                                crop_table(coordinates, x)
                                x += 1
                                
    return koordinate

def crop_table(koordinate, name):
    global blank
    global file_name
    height, width, channels = blank.shape
    global globalname

    x = int(koordinate['Left']*width)
    y = int(koordinate['Top']*height)

    x1 = int((koordinate['Left']*width) + (koordinate['Width']*width))
    y1 = int((koordinate['Top']*height) + (koordinate['Height']*height))

    print(x, y, x1, y1)
    print(width, height)

    crop = blank[y:y1, x:x1]
    
    original = cv2.imread(file_name)
    crop_original = original[y:y1, x:x1]
    
    denoising(crop, crop_original, ime_firme)
    return None


i = 1
#data/skenirano/
file_name = 'scanned.jpg'
start_time = time.time()
img = Image.open(file_name)
width, height = img.size
blank = np.zeros([height,width,3],dtype=np.uint8)
blank.fill(255)
globalname = i
height, width, channels = blank.shape
print(height, width)
initialize()
print(time.time() - start_time)




