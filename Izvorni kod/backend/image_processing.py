from cv2 import cv2
import numpy as np
from table_data import croping

def denoising(im, original,ime_firme):
    morph = im.copy()

    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (1, 1))
    morph = cv2.morphologyEx(morph, cv2.MORPH_CLOSE, kernel)
    morph = cv2.morphologyEx(morph, cv2.MORPH_OPEN, kernel)

    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (2, 2))

    # split the gradient image into channels
    image_channels = np.split(np.asarray(morph), 3, axis=2)

    channel_height, channel_width, _ = image_channels[0].shape

    # apply Otsu threshold to each channel
    for i in range(0, 3):
        _, image_channels[i] = cv2.threshold(image_channels[i], 0, 255, cv2.THRESH_OTSU | cv2.THRESH_BINARY)
        image_channels[i] = np.reshape(image_channels[i], newshape=(channel_height, channel_width, 1))

    # merge the channels
    image_channels = np.concatenate((image_channels[0], image_channels[1], image_channels[2]), axis=2)

    gray = cv2.cvtColor(image_channels, cv2.COLOR_BGR2GRAY)

    gray = cv2.bitwise_not(gray)
    bw = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_MEAN_C, \
                                cv2.THRESH_BINARY, 15, -2)

    text = dilation(bw, original,ime_firme)
    return text

def dilation(bw, original,ime_firme):
    img = bw
    kernel = np.ones((1,1),np.uint8)
    dilation = cv2.dilate(img,kernel,iterations = 1)

    text = columns(dilation, original,ime_firme)
    return text

def columns(bw, img, ime_firme):
    original = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    h, w = bw.shape
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, ksize=(1, 2 * h))
    dilated = cv2.dilate(bw, kernel)

    blended = (original.astype(float) + dilated.astype(float)) / 2
    text = croping(dilated, img, ime_firme)

    return text






