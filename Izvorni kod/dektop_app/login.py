# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'login.ui'
#
# Created by: PyQt5 UI code generator 5.14.1
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets
import pyrebase
from getpass import getpass
from main import Ui_HomeWindow

firebaseConfig = {
 
    "apiKey": "AIzaSyBixl1i-xncwH9JvbtFnPNDMZtCNMmWLko",
    "authDomain": "mytest-91572.firebaseapp.com",
    "databaseURL": "https://mytest-91572.firebaseio.com",
    "projectId": "mytest-91572",
    "storageBucket": "mytest-91572.appspot.com",
    "messagingSenderId": "558021857077",
    "appId": "1:558021857077:web:63b4ff6e71edb9211bc67c",
    "measurementId": "G-HL4NZ8QSN9"
 
}

firebase = pyrebase.initialize_app(firebaseConfig)
auth = firebase.auth()

class Ui_MainWindow(object):
    def openwindow(self):

        self.window = QtWidgets.QMainWindow()
        self.ui = Ui_HomeWindow()
        self.ui.setupUi(self.window)
        MainWindow.hide()
        self.window.show()
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(1002, 595)
        MainWindow.setAutoFillBackground(False)
        MainWindow.setStyleSheet("background-color: rgb(79, 80, 84);")
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.uername_label = QtWidgets.QLabel(self.centralwidget)
        self.uername_label.setGeometry(QtCore.QRect(400, 190, 91, 17))
        self.uername_label.setStyleSheet("color: rgb(255, 255, 255);")
        self.uername_label.setObjectName("uername_label")
        self.pass_label = QtWidgets.QLabel(self.centralwidget)
        self.pass_label.setGeometry(QtCore.QRect(400, 250, 91, 17))
        self.pass_label.setStyleSheet("color: rgb(255, 255, 255);")
        self.pass_label.setObjectName("pass_label")
        self.login_btn = QtWidgets.QPushButton(self.centralwidget)
        self.login_btn.setGeometry(QtCore.QRect(460, 310, 89, 25))
        self.login_btn.setStyleSheet("color: rgb(0, 0, 0);\n"
"background-color: rgb(64, 211, 131);")
        self.login_btn.setObjectName("login_btn")
        self.login_btn.clicked.connect(self.on_click)
        self.user_text = QtWidgets.QLineEdit(self.centralwidget)
        self.user_text.setGeometry(QtCore.QRect(400, 210, 211, 25))
        self.user_text.setStyleSheet("color: rgb(238, 238, 236);")
        self.user_text.setObjectName("user_text")
        self.pass_text = QtWidgets.QLineEdit(self.centralwidget)
        self.pass_text.setEchoMode(QtWidgets.QLineEdit.Password)
        self.pass_text.setGeometry(QtCore.QRect(400, 270, 211, 25))
        self.pass_text.setStyleSheet("color: rgb(238, 238, 236);")
        self.pass_text.setObjectName("pass_text")
        self.logo = QtWidgets.QLabel(self.centralwidget)
        self.logo.setGeometry(QtCore.QRect(460, 70, 101, 101))
        self.logo.setStyleSheet("image: url(:/newPrefix/logo.png);")
        self.logo.setText("")
        self.logo.setObjectName("logo")
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 1002, 22))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "Cornux"))
        self.uername_label.setText(_translate("MainWindow", "Username"))
        self.pass_label.setText(_translate("MainWindow", "Password"))
        self.login_btn.setText(_translate("MainWindow", "LOGIN"))
    
    def on_click(self):
        email = self.user_text.text()
        password = self.pass_text.text()
        try:
            auth.sign_in_with_email_and_password(email, password)
            self.login_btn.clicked.connect(self.openwindow)
        except:
            error = QtWidgets.QMessageBox()
            error.setText('Krivi korisnički podatci!')
            x = error.exec_() 
            error.setIcon(QtWidgets.QMessageBox.Critical)
            error.setDefaultButton(QtWidgets.QMessageBox.Retry)
        

import picture

if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())

