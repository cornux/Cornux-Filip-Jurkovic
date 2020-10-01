from transform import four_point_transform # Učitavamo funkciju iz drugog programa za izravnjavanje slike
# Učitavanje paketa potrebnih za rad koda
import numpy as np
from cv2 import cv2
import imutils
import time

def Edge_detection(image): #Funkcija za detekciju rubova i kuteva slike
	ratio = image.shape[0] / 500.0                	#
	orig = image.copy()								# Manipuliramo veličinom slike kako bismo je mogli koristiti za 
	image = imutils.resize(image, height = 500)     # daljnju obradu

	
	gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)  											     # 
	gray = cv2.GaussianBlur(gray, (5, 5), 0)														 # Pretavranje slike u crno-bijelu sliku te ju zamagljujemo
	img = cv2.medianBlur(gray,5)																	 # kako bismo našli rubove papira
	threshold = cv2.adaptiveThreshold(img,255,cv2.ADAPTIVE_THRESH_GAUSSIAN_C,cv2.THRESH_BINARY,11,2) #

	
	Contours(threshold, ratio, orig) # Pozivanje funkcije u kojoj ćemo naći konture papira

def Contours(threshold, ratio, orig): # Funkcija za pronalazak kontura papira

	cnts = cv2.findContours(threshold.copy(), cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE) #
	cnts = imutils.grab_contours(cnts)												  # Manipuliranje slike kako bismo izvukli njezine kotnure
	cnts = sorted(cnts, key = cv2.contourArea, reverse = True)[:5]					  #

	for c in cnts: # prolazimo kroz sve pronađene konture na slici
		peri = cv2.arcLength(c, True)  					#
		approx = cv2.approxPolyDP(c, 0.02 * peri, True) # Aproksimacija kontura

		# ako naša aproksimirana kotura ima 4 točke
		# možemo pretpostaviti da smo našli naš papir
		if len(approx) == 4:
			screenCnt = approx
			break
	
	
	cv2.drawContours(image, [screenCnt], -1, (0, 255, 0), 2) # crtamo obrub papira
	Perspective_transform(orig, screenCnt, ratio) # Pozivamo funkciju za 2D transoformaciju pronađenog papira

def Perspective_transform(orig, screenCnt, ratio): # Funkcija za 2D transoformaciju pronađenog papira
	warped = four_point_transform(orig, screenCnt.reshape(4, 2) * ratio) # Pozivamo funkciju iz drugog programa za izravnjavanje slike
	warped = cv2.flip(warped, 1) # Zrcalimo izravnanu sliku po Y osi

	height, width, channels = warped.shape # Tražimo dimenzije novodobivene slike

	# Ako nam je širina veća od visine znači da je slika polegnuta na desnu stranu te je trebamo poravnati za 90 stupnjeva
	if width > height: 
		warped = imutils.rotate_bound(warped, -90)

	Shadow_removal(warped) # Pozivamo funkciju za otklanjanje sjene sa slike

def Shadow_removal(warped): # Funkcija za otklanjanje sjene sa slike
	img = warped.copy() # Kopiramo poravnatu sliku pod imenom img
	rgb_planes = cv2.split(img) # Razdvajamo boje RGB spektruma

	result_norm_planes = [] # Niz u koji spremamo normalizirane boje slike
	# Prolazimo kroz sve dijelove boja slike
	for plane in rgb_planes:
		dilated_img = cv2.dilate(plane, np.ones((7,7), np.uint8))   											 #  
		bg_img = cv2.medianBlur(dilated_img, 21)																 # Prolazimo kroz sve 3 boje RGB-a, te 
		diff_img = 255 - cv2.absdiff(plane, bg_img) 															 # Normaliziramo svaku boju kako bi otklonili sjenu
		norm_img = cv2.normalize(diff_img,None, alpha=0, beta=255, norm_type=cv2.NORM_MINMAX, dtype=cv2.CV_8UC1) # 
		result_norm_planes.append(norm_img) # Spremamo narmaliziranu boju u niz 

	result_norm = cv2.merge(result_norm_planes) # Ponovno spajamo sve boje u jednu sliku
	result_norm = cv2.cvtColor(result_norm, cv2.COLOR_BGR2GRAY) # Pretvaramo sliku u crno-bijelu
	
	cv2.imwrite('scanned.jpg', result_norm) # Spremamo sliku kojoj smo otklonili sjenu
	

start_time = time.time() # Startanje timera kako bi se znalo proteklo vrijeme - korišteno za debug
name = 'api.jpg' #Ime datoteke koju otvaramo - spremili smo je u prijašnjem programu
image = cv2.imread(name) #Inicijalizacija OpenCV libraryja sanašom slikom
Edge_detection(image)#Funkcija za detekciju rubova i kuteva slike
import extract_fields #Pokrećemo program za vađenje tablica iz slike
print(time.time() - start_time) #Ispisujemo proteklo vrijeme 