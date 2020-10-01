from cv2 import cv2
import numpy as np
import imutils
import pytesseract
import os
from PIL import Image
import json


def croping(paper, original, ime_firme):

    cells = []
    ret, thresh_gray = cv2.threshold(paper,
                                     200, 255, cv2.THRESH_BINARY)
    contours, hier = cv2.findContours(
        thresh_gray, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    for c in contours:
        rect = cv2.minAreaRect(c)
        box = cv2.boxPoints(rect)
        box = np.int0(box)
        x, y, w, h = cv2.boundingRect(c)

        crop = original[y:y+h, x: x+w]
        textract(crop)
    response = Jsonify()
    print(response)
    f = open('response.txt', 'w')
    f.write(response)
    f.close()


row = []
columns = []


def textract(crop):
    global row
    global columns
    text = pytesseract.image_to_string(crop, config='--psm 6', lang='hrv')
    words = text.split("\n")

    columns.append(words[0])
    words.pop(0)
    row.append(words)


def Jsonify():
    global columns
    global row

    columnsArray = columns[::-1]
    rowArray = row[::-1]
    print(row)
    print(rowArray)
    print(columns)
    print(columnsArray)
    list_len = [len(i) for i in rowArray]
    num = max(list_len)
    colLen = len(columnsArray)
    response = '['
    for i in range(num):
        row = '{'
        for j in range(colLen):
            rowLen = len(rowArray[j])-1
            if i > rowLen:
                if j == colLen-1:
                    row = row + json.dumps(columnsArray[j])+': ' + '" "'
                else:
                    row = row + json.dumps(columnsArray[j])+': ' + '" ",'
            else:
                if rowArray[j][i].isdigit():
                    if j == colLen-1:
                        row = row + json.dumps(columnsArray[j])+': '+rowArray[j][i]
                    else:
                        row = row + json.dumps(columnsArray[j])+': '+rowArray[j][i]+','
                
                else:
                    if j == colLen-1:
                        row = row + json.dumps(columnsArray[j])+': '+json.dumps(rowArray[j][i])
                    else:
                        row = row + json.dumps(columnsArray[j])+': '+json.dumps(rowArray[j][i])+','
                
        if i == num -1:
            row = row + '}'
        else:
            row = row + '},'
        response = response + row

    response = response + ']'
    return response
