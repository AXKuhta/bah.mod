' Copyright (c) 2014-2016 Bruce A Henderson
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.
'
SuperStrict

Import BRL.Blitz

Import "scintilla/include/*.h"
Import "scintilla/lexlib/*.h"
Import "scintilla/src/*.h"
?linux
Import "scintilla/gtk/*.h"
?macos
Import "scintilla/cocoa/*.h"
?win32
Import "scintilla/win32/*.h"
?

' src
Import "scintilla/src/AutoComplete.cxx"
Import "scintilla/src/CallTip.cxx"
Import "scintilla/src/CaseConvert.cxx"
Import "scintilla/src/CaseFolder.cxx"
Import "scintilla/src/Catalogue.cxx"
Import "scintilla/src/CellBuffer.cxx"
Import "scintilla/src/CharClassify.cxx"
Import "scintilla/src/ContractionState.cxx"
Import "scintilla/src/Decoration.cxx"
Import "scintilla/src/Document.cxx"
Import "scintilla/src/EditModel.cxx"
Import "scintilla/src/Editor.cxx"
Import "scintilla/src/EditView.cxx"
Import "scintilla/src/ExternalLexer.cxx"
Import "scintilla/src/Indicator.cxx"
Import "scintilla/src/KeyMap.cxx"
Import "scintilla/src/LineMarker.cxx"
Import "scintilla/src/MarginView.cxx"
Import "scintilla/src/PerLine.cxx"
Import "scintilla/src/PositionCache.cxx"
Import "scintilla/src/RESearch.cxx"
Import "scintilla/src/RunStyles.cxx"
Import "scintilla/src/ScintillaBase.cxx"
Import "scintilla/src/Selection.cxx"
Import "scintilla/src/Style.cxx"
Import "scintilla/src/UniConversion.cxx"
Import "scintilla/src/ViewStyle.cxx"
Import "scintilla/src/XPM.cxx"

' lexlib
Import "scintilla/lexlib/Accessor.cxx"
Import "scintilla/lexlib/CharacterCategory.cxx"
Import "scintilla/lexlib/CharacterSet.cxx"
Import "scintilla/lexlib/LexerBase.cxx"
Import "scintilla/lexlib/LexerModule.cxx"
Import "scintilla/lexlib/LexerNoExceptions.cxx"
Import "scintilla/lexlib/LexerSimple.cxx"
Import "scintilla/lexlib/PropSetSimple.cxx"
Import "scintilla/lexlib/StyleContext.cxx"
Import "scintilla/lexlib/WordList.cxx"

' lexers
Import "scintilla/lexers/LexA68k.cxx"
Import "scintilla/lexers/LexAbaqus.cxx"
Import "scintilla/lexers/LexAda.cxx"
Import "scintilla/lexers/LexAPDL.cxx"
Import "scintilla/lexers/LexAsm.cxx"
Import "scintilla/lexers/LexAsn1.cxx"
Import "scintilla/lexers/LexASY.cxx"
Import "scintilla/lexers/LexAU3.cxx"
Import "scintilla/lexers/LexAVE.cxx"
Import "scintilla/lexers/LexAVS.cxx"
Import "scintilla/lexers/LexBaan.cxx"
Import "scintilla/lexers/LexBash.cxx"
Import "scintilla/lexers/LexBasic.cxx"
Import "scintilla/lexers/LexBullant.cxx"
Import "scintilla/lexers/LexCaml.cxx"
Import "scintilla/lexers/LexCLW.cxx"
Import "scintilla/lexers/LexCmake.cxx"
Import "scintilla/lexers/LexCOBOL.cxx"
Import "scintilla/lexers/LexCoffeeScript.cxx"
Import "scintilla/lexers/LexConf.cxx"
Import "scintilla/lexers/LexCPP.cxx"
Import "scintilla/lexers/LexCrontab.cxx"
Import "scintilla/lexers/LexCsound.cxx"
Import "scintilla/lexers/LexCSS.cxx"
Import "scintilla/lexers/LexD.cxx"
Import "scintilla/lexers/LexDMAP.cxx"
Import "scintilla/lexers/LexECL.cxx"
Import "scintilla/lexers/LexEiffel.cxx"
Import "scintilla/lexers/LexErlang.cxx"
Import "scintilla/lexers/LexEScript.cxx"
Import "scintilla/lexers/LexFlagship.cxx"
Import "scintilla/lexers/LexForth.cxx"
Import "scintilla/lexers/LexFortran.cxx"
Import "scintilla/lexers/LexGAP.cxx"
Import "scintilla/lexers/LexGui4Cli.cxx"
Import "scintilla/lexers/LexHaskell.cxx"
Import "scintilla/lexers/LexHTML.cxx"
Import "scintilla/lexers/LexInno.cxx"
Import "scintilla/lexers/LexKix.cxx"
Import "scintilla/lexers/LexKVIrc.cxx"
Import "scintilla/lexers/LexLaTeX.cxx"
Import "scintilla/lexers/LexLisp.cxx"
Import "scintilla/lexers/LexLout.cxx"
Import "scintilla/lexers/LexLua.cxx"
Import "scintilla/lexers/LexMagik.cxx"
Import "scintilla/lexers/LexMarkdown.cxx"
Import "scintilla/lexers/LexMatlab.cxx"
Import "scintilla/lexers/LexMax.cxx" ' BlitzMax lexer
Import "scintilla/lexers/LexMetapost.cxx"
Import "scintilla/lexers/LexMMIXAL.cxx"
Import "scintilla/lexers/LexModula.cxx"
Import "scintilla/lexers/LexMPT.cxx"
Import "scintilla/lexers/LexMSSQL.cxx"
Import "scintilla/lexers/LexMySQL.cxx"
Import "scintilla/lexers/LexNimrod.cxx"
Import "scintilla/lexers/LexNsis.cxx"
Import "scintilla/lexers/LexOpal.cxx"
Import "scintilla/lexers/LexOScript.cxx"
Import "scintilla/lexers/LexOthers.cxx"
Import "scintilla/lexers/LexPascal.cxx"
Import "scintilla/lexers/LexPB.cxx"
Import "scintilla/lexers/LexPerl.cxx"
Import "scintilla/lexers/LexPLM.cxx"
Import "scintilla/lexers/LexPO.cxx"
Import "scintilla/lexers/LexPOV.cxx"
Import "scintilla/lexers/LexPowerPro.cxx"
Import "scintilla/lexers/LexPowerShell.cxx"
Import "scintilla/lexers/LexProgress.cxx"
Import "scintilla/lexers/LexPS.cxx"
Import "scintilla/lexers/LexPython.cxx"
Import "scintilla/lexers/LexR.cxx"
Import "scintilla/lexers/LexRebol.cxx"
Import "scintilla/lexers/LexRuby.cxx"
Import "scintilla/lexers/LexRust.cxx"
Import "scintilla/lexers/LexScriptol.cxx"
Import "scintilla/lexers/LexSmalltalk.cxx"
Import "scintilla/lexers/LexSML.cxx"
Import "scintilla/lexers/LexSorcus.cxx"
Import "scintilla/lexers/LexSpecman.cxx"
Import "scintilla/lexers/LexSpice.cxx"
Import "scintilla/lexers/LexSQL.cxx"
Import "scintilla/lexers/LexSTTXT.cxx"
Import "scintilla/lexers/LexTACL.cxx"
Import "scintilla/lexers/LexTADS3.cxx"
Import "scintilla/lexers/LexTAL.cxx"
Import "scintilla/lexers/LexTCL.cxx"
Import "scintilla/lexers/LexTCMD.cxx"
Import "scintilla/lexers/LexTeX.cxx"
Import "scintilla/lexers/LexTxt2tags.cxx"
Import "scintilla/lexers/LexVB.cxx"
Import "scintilla/lexers/LexVerilog.cxx"
Import "scintilla/lexers/LexVHDL.cxx"
Import "scintilla/lexers/LexVisualProlog.cxx"
Import "scintilla/lexers/LexYAML.cxx"

?linux
' gtk
Import "scintilla/gtk/PlatGTK.cxx"
Import "scintilla/gtk/ScintillaGTK.cxx"
Import "scintilla/gtk/scintilla-marshal.c"

Import "linux_glue.c"
?macos
' cocoa
Import "scintilla/cocoa/PlatCocoa.mm"
Import "scintilla/cocoa/ScintillaCocoa.mm"
Import "scintilla/cocoa/ScintillaView.mm"

Import "macos_glue.mm"
?win32
' win32
Import "scintilla/win32/PlatWin.cxx"
Import "scintilla/win32/ScintillaWin.cxx"
?


