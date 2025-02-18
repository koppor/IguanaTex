VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} SetTempForm 
   Caption         =   "Default Settings and Paths"
   ClientHeight    =   10896
   ClientLeft      =   -12
   ClientTop       =   204
   ClientWidth     =   6240
   OleObjectBlob   =   "SetTempForm.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "SetTempForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private UsePDFList As Variant

Sub ButtonCancelTemp_Click()
    Unload SetTempForm
End Sub

Private Sub ButtonAbsTempPath_Click()
    AbsPathTextBox.Text = BrowseFolderPath(AbsPathTextBox.Text)
    AbsPathTextBox.SetFocus
End Sub

Private Sub ButtonEditorPath_Click()
    #If Mac Then
        TextBoxExternalEditor.Text = "open -b " & ShellEscape(MacChooseApp(TextBoxExternalEditor.Text))
    #Else
        TextBoxExternalEditor.Text = BrowseFilePath(TextBoxExternalEditor.Text, "All Files", "*.*")
    #End If
    TextBoxExternalEditor.SetFocus
End Sub

Private Sub ButtonGSPath_Click()
    TextBoxGS.Text = BrowseFilePath(TextBoxGS.Text, "All Files", "*.*")
    TextBoxGS.SetFocus
End Sub

Private Sub ButtonIMPath_Click()
    TextBoxIMconv.Text = BrowseFilePath(TextBoxIMconv.Text, "All Files", "*.*")
    TextBoxIMconv.SetFocus
End Sub

Private Sub ButtonTeX2img_Click()
    TextBoxTeX2img.Text = BrowseFilePath(TextBoxTeX2img.Text, "All Files", "*.*")
    TextBoxTeX2img.SetFocus
End Sub

Private Sub ButtonTeXExePath_Click()
    TextBoxTeXExePath.Text = BrowseFolderPath(TextBoxTeXExePath.Text)
    TextBoxTeXExePath.SetFocus
End Sub

Private Sub ButtonLaTeXiTPath_Click()
    TextBoxLaTeXiT.Text = BrowseFilePath(TextBoxLaTeXiT.Text, "All Files", "*.*")
    TextBoxLaTeXiT.SetFocus
End Sub

Private Sub ButtonLibgsPath_Click()
    TextBoxLibgs.Text = BrowseFilePath(TextBoxLibgs.Text, "dylib Files", "*.dylib")
    TextBoxLibgs.SetFocus
End Sub

Sub ButtonSetTemp_Click()
    Dim res As String
    
    ' Temp folder
    SetITSetting "AbsOrRel", REG_DWORD, BoolToInt(AbsPathButton.value)
    SetITSetting "Abs Temp Dir", REG_SZ, CStr(AbsPathTextBox.Text)
    If Left$(RelPathTextBox.Text, 2) = "." & PathSep Then
        RelPathTextBox.Text = Mid$(RelPathTextBox.Text, 3, Len(RelPathTextBox.Text) - 2)
    End If
    SetITSetting "Rel Temp Dir", REG_SZ, CStr(RelPathTextBox.Text)
    
    If AbsPathButton.value = True Then
        res = AbsPathTextBox.Text
    Else
        res = "." & PathSep & RelPathTextBox.Text
    End If
    res = AddTrailingSlash(res)
    SetITSetting "Temp Dir", REG_SZ, CStr(res)
    
    ' UTF8
    'SetITSetting "UseUTF8", REG_DWORD, BoolToInt(CheckBoxUTF8.Value)
    
    ' Vector or Bitmap (EMF or PNG)
    'SetITSetting "EMFoutput", REG_DWORD, BoolToInt(CheckBoxEMF.Value)
    SetITSetting "BitmapVector", REG_DWORD, ComboBoxBitmapVector.ListIndex
    
    Dim VectorOutputTypeList As Variant
    VectorOutputTypeList = GetVectorOutputTypeList()
    Dim VectorOutputType As String
    VectorOutputType = VectorOutputTypeList(ComboBoxVectorOutputType.ListIndex)
    SetITSetting "VectorOutputTypeIdx", REG_DWORD, ComboBoxVectorOutputType.ListIndex
    SetITSetting "VectorOutputType", REG_SZ, CStr(VectorOutputType)
    
    
    ' GS command
    #If Mac Then
        ' no need to remove quotes on mac because we use open -b '....'
        res = TextBoxGS.Text
    #Else
        res = RemoveQuotes(TextBoxGS.Text)
        ' Make sure the user pointed to the "c.exe" version (if they used a ".exe" executable)
        If Right$(res, 4) = ".exe" And Right$(res, 5) <> "c.exe" Then
            res = Left$(res, Len(res) - 4) & "c.exe"
        End If
    #End If
    SetITSetting "GS Command", REG_SZ, CStr(res)
    
    ' Path to ImageMagick Convert
    res = RemoveQuotes(TextBoxIMconv.Text)
    SetITSetting "IMconv", REG_SZ, CStr(res)
    
    ' Path to External Editor
    res = RemoveQuotes(TextBoxExternalEditor.Text)
    SetITSetting "Editor", REG_SZ, CStr(res)
    ' Use External Editor by default
    SetITSetting "UseExternalEditor", REG_DWORD, BoolToInt(CheckBoxExternalEditor.value)
    
    
    ' Path to TeX2img (Vector output)
    res = RemoveQuotes(TextBoxTeX2img.Text)
    SetITSetting "TeX2img Command", REG_SZ, CStr(res)
    
    ' Path to TeX Executables Folder
    res = RemoveQuotes(TextBoxTeXExePath.Text)
    res = AddTrailingSlash(res)
    SetITSetting "TeXExePath", REG_SZ, CStr(res)
    
    ' Path to LaTeXiT-metadata extractor
    res = RemoveQuotes(TextBoxLaTeXiT.Text)
    SetITSetting "LaTeXiT", REG_SZ, CStr(res)
    
    ' Path to Libgs (Mac only)
    res = RemoveQuotes(TextBoxLibgs.Text)
    SetITSetting "Libgs", REG_SZ, CStr(res)
    
    ' Magic scaling factor to fine-tune the scaling of Vector displays
    SetITSetting "VectorScalingX", REG_SZ, TextBoxVectorScalingX.Text
    SetITSetting "VectorScalingY", REG_SZ, TextBoxVectorScalingY.Text
    
    ' Magic scaling factor to fine-tune the scaling of PNG displays
    SetITSetting "BitmapScalingX", REG_SZ, TextBoxBitmapScalingX.Text
    SetITSetting "BitmapScalingY", REG_SZ, TextBoxBitmapScalingY.Text
    
    ' Global dpi setting for latex output
    SetITSetting "OutputDpi", REG_DWORD, CLng(val(TextBoxDpi.Text))
    
    ' Time Out Interval for Processes
    SetITSetting "TimeOutTime", REG_DWORD, CLng(val(TextBoxTimeOut.Text))
    
    ' Font size for text in editor/template windows
    SetITSetting "EditorFontSize", REG_DWORD, CLng(val(TextBoxFontSize.Text))
    
    ' LaTeX Engine
    'SetITSetting "LaTeXEngine", REG_SZ, CStr(ComboBoxEngine.Text)
    SetITSetting "LaTeXEngineID", REG_DWORD, ComboBoxEngine.ListIndex

    ' Use Latexmk by default
    SetITSetting "UseLatexmk", REG_DWORD, BoolToInt(CheckBoxLatexmk.value)
    
    ' Keep Temporary files by default
    SetITSetting "KeepTempFiles", REG_DWORD, BoolToInt(CheckBoxKeepTempFiles.value)
    
    ' Height and Width of the Editor Window on Mac (until we make it resizable)
    #If Mac Then
        SetITSetting "LatexFormHeight", REG_DWORD, CLng(val(TextBoxWindowHeight.Text))
        SetITSetting "LatexFormWidth", REG_DWORD, CLng(val(TextBoxWindowWidth.Text))
    #End If
    
    Unload SetTempForm
End Sub


Private Sub AbsPathButton_Click()
    AbsPathButton.value = True
    SetAbsRelDependencies
End Sub


Private Sub LabelDLgs_Click()
    OpenURL "http://www.ghostscript.com/download/gsdnld.html"
End Sub

Private Sub LabelDLImageMagick_Click()
    OpenURL "http://www.imagemagick.org/script/download.php#windows"
End Sub

Private Sub LabelDLTeX2img_Click()
    #If Mac Then
        OpenURL "https://tex2img.tech/#DOWNLOAD"
    #Else
        OpenURL "https://www.ms.u-tokyo.ac.jp/~abenori/soft/bin/TeX2img_2.1.0.zip"
    #End If
End Sub

Private Sub LabelTeX2imgGithub_Click()
    OpenURL "https://github.com/abenori/TeX2img"
End Sub

Private Sub LabelDLtexstudio_Click()
    OpenURL "http://www.texstudio.org/"
End Sub

Private Sub RelPathButton_Click()
    AbsPathButton.value = False
    SetAbsRelDependencies
End Sub

Private Sub SetAbsRelDependencies()
    RelPathButton.value = Not AbsPathButton.value
    AbsPathTextBox.Enabled = AbsPathButton.value
    RelPathTextBox.Enabled = RelPathButton.value
End Sub

Private Sub SetPDFdependencies()
    If UsePDFList(ComboBoxEngine.ListIndex) = True Then
        TextBoxGS.Enabled = True
        TextBoxIMconv.Enabled = True
    Else
        TextBoxGS.Enabled = False
        TextBoxIMconv.Enabled = False
    End If
End Sub

Sub ButtonReset_Click()
    AbsPathButton.value = True
    AbsPathTextBox.Text = DEFAULT_TEMP_DIR
    
    'CheckBoxUTF8.Value = True
    
    CheckBoxExternalEditor.value = False
    
    CheckBoxLatexmk.value = False
    CheckBoxKeepTempFiles.value = True
    'CheckBoxEMF.Value = False
    ComboBoxBitmapVector.ListIndex = 0
    ComboBoxVectorOutputType.ListIndex = 0
    
    TextBoxGS.Text = DEFAULT_GS_COMMAND
    
    TextBoxIMconv.Text = DEFAULT_IM_CONV
    
    Dim UserProfile As String
    #If Mac Then
        UserProfile = vbNullString
    #Else
        UserProfile = Environ$("USERPROFILE")
    #End If
    TextBoxTeX2img.Text = Replace(DEFAULT_TEX2IMG_COMMAND, "%USERPROFILE%", UserProfile)
    
    TextBoxExternalEditor.Text = DEFAULT_EDITOR
    
    TextBoxTeXExePath.Text = DEFAULT_TEX_EXE_PATH
    
    TextBoxLaTeXiT.Text = Replace(DEFAULT_LATEXIT_METADATA_COMMAND, "%USERPROFILE%", UserProfile)
    
    TextBoxLibgs.Text = DEFAULT_LIBGS
    
    TextBoxDpi.Text = "1200"
    
    TextBoxVectorScalingX.Text = "1"
    TextBoxVectorScalingY.Text = "1"
    
    TextBoxBitmapScalingX.Text = "1"
    TextBoxBitmapScalingY.Text = "1"
    
    TextBoxTimeOut.Text = "60"
    
    TextBoxFontSize.Text = "10"
    
    TextBoxWindowHeight.Text = "320"
    TextBoxWindowWidth.Text = "385"
    
    ComboBoxEngine.ListIndex = 0
    
    SetAbsRelDependencies
    
End Sub

Private Sub UserForm_Activate()
    #If Mac Then
        MacEnableCopyPaste Me
        MacEnableAccelerators Me
    #End If
End Sub


Private Sub UserForm_Initialize()
    
    Me.Top = Application.Top + 110
    Me.Left = Application.Left + 25
    ' I'm fixing the height because I have been getting issues with form automatically resizing
    ' to something too small, resulting in very small font
    Me.Height = 480
    Me.Width = 320
    #If Mac Then
        'Me.ComboBoxVectorOutputType.Enabled = False
        Me.LabelSetGS.Caption = "Set ghostscript command (gs)"
        Me.LabelLibgs.Top = Me.LabelSetFullPath.Top
        Me.LabelSetFullPath.Visible = False
        Me.LabelTeX2img.Visible = False
        Me.TextBoxLibgs.Top = Me.TextBoxIMconv.Top
        Me.TextBoxIMconv.Visible = False
        Me.TextBoxTeX2img.Visible = False
        Me.ButtonLibgsPath.Top = Me.ButtonIMPath.Top
        Me.ButtonIMPath.Visible = False
        Me.ButtonTeX2img.Visible = False
        Me.LabelTeX2imgGithub.Visible = False
        Me.LabelDLTeX2img.Visible = False
        Me.LabelDLImageMagick.Visible = False
        Me.LabelWindowSize.Top = Me.TextBoxLaTeXiT.Top + 26
        Me.LabelWindowHeight.Top = Me.LabelWindowSize.Top
        Me.LabelWindowWidth.Top = Me.LabelWindowHeight.Top
        Me.TextBoxWindowHeight.Top = Me.LabelWindowHeight.Top - 2
        Me.TextBoxWindowWidth.Top = Me.TextBoxWindowHeight.Top
        Me.LabelFontSize.Caption = "Font size="
        Me.LabelFontSize.Left = 220
        Me.LabelFontSize.Width = 52
        Me.LabelFontSize.Top = Me.LabelWindowSize.Top
        Me.TextBoxFontSize.Top = Me.TextBoxWindowHeight.Top
        Me.ButtonCancelTemp.Top = Me.LabelWindowSize.Top + 24
        Me.ButtonSetTemp.Top = Me.ButtonCancelTemp.Top
        Me.ButtonReset.Top = Me.ButtonCancelTemp.Top
        Me.Height = Me.ButtonCancelTemp.Top + 56
        ResizeUserForm Me
    #Else
        Me.Height = 430
        Me.TextBoxLibgs.Visible = False
        Me.LabelLibgs.Visible = False
        Me.ButtonLibgsPath.Visible = False
        Me.LabelWindowSize.Visible = False
        Me.LabelWindowHeight.Visible = False
        Me.LabelWindowWidth.Visible = False
        Me.TextBoxWindowHeight.Visible = False
        Me.TextBoxWindowWidth.Visible = False
        Me.ButtonCancelTemp.Top = Me.TextBoxTeX2img.Top + 26
        Me.ButtonSetTemp.Top = Me.ButtonCancelTemp.Top
        Me.ButtonReset.Top = Me.ButtonCancelTemp.Top
        Me.Height = Me.ButtonCancelTemp.Top + 56
    #End If
    
    Dim res As String
    res = GetITSetting("Abs Temp Dir", DEFAULT_TEMP_DIR)
    res = AddTrailingSlash(res)
    AbsPathTextBox.Text = res
    
    RelPathTextBox.Text = GetITSetting("Rel Temp Dir", vbNullString)
    
    AbsPathButton.value = GetITSetting("AbsOrRel", True)
    
    ' We now make UTF-8 the only choice
    'CheckBoxUTF8.Value = GetITSetting("UseUTF8", True)
    'CheckBoxUTF8.Visible = False
    'CheckBoxUTF8.Enabled = False
    
    TextBoxGS.Text = GetITSetting("GS Command", DEFAULT_GS_COMMAND)
    
    TextBoxIMconv.Text = GetITSetting("IMconv", DEFAULT_IM_CONV)
    
    TextBoxDpi.Text = GetITSetting("OutputDpi", "1200")
    
    TextBoxTimeOut.Text = GetITSetting("TimeOutTime", "60")
    
    TextBoxFontSize.Text = GetITSetting("EditorFontSize", "10")
    
    TextBoxVectorScalingX.Text = GetITSetting("VectorScalingX", "1")
    TextBoxVectorScalingY.Text = GetITSetting("VectorScalingY", "1")
    
    TextBoxBitmapScalingX.Text = GetITSetting("BitmapScalingX", "1")
    TextBoxBitmapScalingY.Text = GetITSetting("BitmapScalingY", "1")
    
    TextBoxExternalEditor.Text = GetITSetting("Editor", DEFAULT_EDITOR)
    CheckBoxExternalEditor.value = GetITSetting("UseExternalEditor", False)
    
    Dim UserProfile As String
    #If Mac Then
        UserProfile = vbNullString
    #Else
        UserProfile = Environ$("USERPROFILE")
    #End If
    ' We need to replace %USERPROFILE% by its actual value because that type of path does not play well with CreateProcess API call
    TextBoxTeX2img.Text = Replace(GetITSetting("TeX2img Command", DEFAULT_TEX2IMG_COMMAND), "%USERPROFILE%", UserProfile)
    'TextBoxTeX2img.Text = GetITSetting("TeX2img Command", DEFAULT_TEX2IMG_COMMAND)
    
    TextBoxTeXExePath.Text = GetITSetting("TeXExePath", DEFAULT_TEX_EXE_PATH)
    
    TextBoxLaTeXiT.Text = Replace(GetITSetting("LaTeXiT", DEFAULT_LATEXIT_METADATA_COMMAND), "%USERPROFILE%", UserProfile)
    'TextBoxLaTeXiT.Text = GetITSetting("LaTeXiT", DEFAULT_LATEXIT_METADATA_COMMAND)
    TextBoxLibgs.Text = GetITSetting("Libgs", DEFAULT_LIBGS)
    
    'CheckBoxEMF.Value = GetITSetting("EMFoutput", False)
    ComboBoxBitmapVector.List = GetBitmapVectorList()
    ComboBoxBitmapVector.ListIndex = GetITSetting("BitmapVector", 0)
    ComboBoxVectorOutputType.List = GetVectorOutputTypeDisplayList()
    ComboBoxVectorOutputType.ListIndex = GetITSetting("VectorOutputTypeIdx", 0)
    ComboBoxVectorOutputType.ControlTipText = "SVG via DVI w/ dvisvgm is recommended due to issues with PDF"
    
    UsePDFList = GetUsePDFList()
    
    ComboBoxEngine.List = GetLaTexEngineDisplayList()
    ComboBoxEngine.ListIndex = GetITSetting("LaTeXEngineID", 0)
    'CheckBoxPDF.Value = GetITSetting("UsePDF", False)
    
    CheckBoxLatexmk.value = GetITSetting("UseLatexmk", False)
    CheckBoxKeepTempFiles.value = GetITSetting("KeepTempFiles", True)
    
    ' Latex editor window size on Mac
    TextBoxWindowHeight.Text = GetITSetting("LatexFormHeight", 320)
    TextBoxWindowWidth.Text = GetITSetting("LatexFormWidth", 385)
    
    'SetPDFdependencies
    SetAbsRelDependencies
End Sub

