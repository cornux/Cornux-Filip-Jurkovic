from flask import Flask

UPLOAD_FOLDER = '/home/filipjurko13/Documents/Backend'

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
