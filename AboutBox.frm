VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} AboutBox 
   Caption         =   "IguanaTex"
   ClientHeight    =   5286
   ClientLeft      =   48
   ClientTop       =   330
   ClientWidth     =   8790.001
   OleObjectBlob   =   "AboutBox.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "AboutBox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub CloseAboutButton_Click()
    Unload AboutBox
End Sub


Private Sub LabelURL_Click()
    OpenURL "http://www.jonathanleroux.org/software/iguanatex/"
End Sub

Private Sub UserForm_Initialize()
    Me.Top = Application.Top + 110
    Me.Left = Application.Left + 25
    Me.Height = 288
    Me.Width = 448
    Me.LabelAuthors.Caption = "by Jonathan Le Roux and Zvika Ben-Haim" & NEWLINE & NEWLINE & "Mac version by Tsung-Ju Chiang and Jonathan Le Roux"
    #If Mac Then
        ResizeUserForm Me
    #End If
End Sub
