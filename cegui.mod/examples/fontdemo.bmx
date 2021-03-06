SuperStrict

Framework BaH.CEGUIOpenGL
Import BRL.GLGraphics
Import BRL.GLMax2d

Import "examples_base.bmx"

Graphics 800, 600, 0

HideMouse

' Initialize CEGUI !
Init_CEGUI(New TCEOpenGLRenderer)



Global fontlist:String[] = ["DejaVuSans-10", "fkp-16", "Sword-26", "Batang-26"]

Type TLang
	Field language:String
	Field font:String
	Field text:String
	
	Function Set:TLang(language:String, font:String, text:String)
		Local this:TLang = New TLang
		this.language = language
		this.text = text
		this.font = font
		Return this
	End Function
	
End Type

Global LangList:TLang[] = [ TLang.Set("English", "DejaVuSans-10", "THIS IS SOME TEXT IN UPPERCASE~nand this is lowercase...~n" + ..
	"Try Catching The Brown Fox While It's Jumping Over The Lazy Dog"), ..
	TLang.Set("Русский", "DejaVuSans-10", ..
		"Всё ускоряющаяся эволюция компьютерных технологий предъявила жёсткие требования к производителям как собственно вычислительной техники, так и периферийных устройств.~n" + ..
		"~nЗавершён ежегодный съезд эрудированных школьников, мечтающих глубоко проникнуть в тайны физических явлений и химических реакций.~n" + ..
		"~nавтор панграмм -- Андрей Николаев~n" ), ..
	TLang.Set("Română", "DejaVuSans-10", "CEI PATRU APOSTOLI~n" + ..
		"au fost trei:~n" + ..
		"Luca şi Matfei~n" ), ..
	TLang.Set("Dansk", "DejaVuSans-10", "FARLIGE STORE BOGSTAVER~n" + ..
		"og flere men små...~n" + ..
		"Quizdeltagerne spiste jordbær med fløde, mens cirkusklovnen Walther spillede på xylofon~n" ), ..
	TLang.Set("Japanese", "Sword-26", "日本語を選択~n" + ..
		"トリガー検知~n" + ..
		"鉱石備蓄不足~n" ), ..
	TLang.Set("Korean", "Batang-26", "한국어를 선택~n" + ..
		"트리거 검지~n" + ..
		"광석 비축부족~n" ), ..
	TLang.Set("Việt", "DejaVuSans-10", "Chào CrazyEddie !~n" + ..
		"Mình rất hạnh phúc khi nghe bạn nói điều đó~n" + ..
		"Hy vọng sớm được thấy CEGUI hỗ trợ đầy đủ tiếng Việt~n" + ..
		"Cám ơn bạn rất nhiều~n" + ..
		"Chúc bạn sức khoẻ~n" + ..
		"Tạm biệt !~n" ) ]


Const MIN_POINT_SIZE:Float = 10.0





Local app:MyApp = New MyApp
app.run()




' Sample sub-class for ListboxTextItem that auto-sets the selection brush
' image.  This saves doing it manually every time in the code.
Type MyListItem Extends TCEListboxTextItem

	Method onInit()
		setSelectionBrushImageByName("TaharezLook", "MultiListSelectionBrush")
	End Method

End Type

Type MyApp Extends CEGuiBaseApplication

	Method initialise:Int()
		
		' load scheme and set up defaults
		TCESchemeManager.CreateScheme("TaharezLook.scheme")
		TCESystem.setDefaultMouseCursor ("TaharezLook", "MouseArrow")
		
		' Create a custom font which we use to draw the list items. This custom
		' font won't get effected by the scaler and such.
		TCEFontManager.createFreeTypeFont("DefaultFont", 10, True, "DejaVuSans.ttf")
		' Set it as the default
		TCESystem.setDefaultFont("DefaultFont")
		
		' load all the fonts (if they are not loaded yet)
		For Local i:Int = 0 Until FontList.length
			TCEFontManager.CreateFont(FontList[i] + ".font")
		Next
		
		' load an image to use as a background
		TCEImagesetManager.createImageSetFromImageFile("BackgroundImage", "GPN-2000-001437.tga")
		
		' here we will use a StaticImage as the root, then we can use it to place a background image
		Local background:TCEWindow = TCEWindowManager.CreateWindow("TaharezLook/StaticImage")
		' set area rectangle
		background.setAreaRel(0, 0, 1, 1)
		' disable frame and standard background
		background.setProperty("FrameEnabled", "false")
		background.setProperty("BackgroundEnabled", "false")
		' set the background image
		background.setProperty("Image", "set:BackgroundImage image:full_image")
		' install this as the root GUI sheet
		TCESystem.setGUISheet(background)
		
		' set tooltip styles (by default there is none)
		TCESystem.setDefaultTooltip("TaharezLook/Tooltip")
		
		' load some demo windows and attach to the background 'root'
		background.addChild(TCEWindowManager.loadWindowLayout ("FontDemo.layout"))
		
		' Add the font names to the listbox
		Local lbox:TCEListbox = TCEListbox(TCEWindowManager.getWindow("FontDemo/FontList"))
		lbox.setFont("DefaultFont")
		For Local i:Int = 0 Until FontList.length
			lbox.addItem (New MyListItem.Create(FontList[i]))
		Next
		' set up the font listbox callback
		lbox.subscribeEvent (TCEListbox.EventSelectionChanged, handleFontSelection)
		' select the first font
		lbox.setItemSelectStateForIndex(0, True)
		
		' Add language list to the listbox
		lbox = TCEListbox(TCEWindowManager.getWindow("FontDemo/LangList"))
		lbox.setFont("DefaultFont")
		For Local i:Int = 0  Until LangList.length
			' only add a language if 'preferred' font is available
			If TCEFontManager.isDefined(LangList[i].Font) Then
				lbox.addItem(New MyListItem.Create(LangList[i].Language))
			End If
		Next
		
		' set up the language listbox callback
		lbox.subscribeEvent(TCEListbox.EventSelectionChanged, handleLangSelection)
		' select the first language
		lbox.setItemSelectStateForIndex(0, True)
		
		TCEWindowManager.getWindow("FontDemo/AutoScaled").subscribeEvent(TCECheckbox.EventCheckStateChanged, handleAutoScaled)
		TCEWindowManager.getWindow("FontDemo/Antialiased").subscribeEvent(TCECheckbox.EventCheckStateChanged, handleAntialiased)
		TCEWindowManager.getWindow("FontDemo/PointSize").subscribeEvent(TCEScrollbar.EventScrollPositionChanged, handlePointSize)
		
		Return True

	End Method


	' When a fonts get selected from the list, we update the name field. Of course,
	' this can be done easier (by passing the selected font), but this demonstrates how 
	' to query a widget's font.
	Function setFontDesc()
		Local mle:TCEMultiLineEditbox = TCEMultiLineEditbox(TCEWindowManager.getWindow("FontDemo/FontSample"))
		
		' Query the font from the textbox
		Local f:TCEFont = mle.getFont()
		
		' Build up the font name...
		Local s:String = f.getProperty("Name")
		If f.isPropertyPresent("PointSize") Then
			s :+ "." + f.getProperty("PointSize")
		End If
		
		' ...and set it
		TCEWindowManager.getWindow("FontDemo/FontDesc").setText(s)
	End Function

	' Called when the used selects a different font from the font list.
	Function handleFontSelection:Int(e:TCEEventArgs)

		' Access the listbox which sent the event
		Local lbox:TCEListbox = TCEListbox(TCEWindowEventArgs(e).getWindow())
		
		If lbox.getFirstSelectedItem() Then
			' Read the fontname and get the font by that name
			Local font:TCEFont = TCEFontManager.get(lbox.getFirstSelectedItem().getText())
			
			' Tell the textbox to use the newly selected font
			TCEWindowManager.getWindow("FontDemo/FontSample").setFont(font)
			
			Local b:Int = font.isPropertyPresent("AutoScaled")
			Local cb:TCECheckbox = TCECheckbox(TCEWindowManager.getWindow("FontDemo/AutoScaled"))
			cb.setEnabled(b)
			If b Then
				cb.setSelected(font.getPropertyAsBool("AutoScaled"))
			End If
			
			b = font.isPropertyPresent("Antialiased")
			cb = TCECheckbox(TCEWindowManager.getWindow("FontDemo/Antialiased"))
			cb.setEnabled (b)
			If b Then
				cb.setSelected(font.getPropertyAsBool("Antialiased"))
			End If
			
			b = font.isPropertyPresent ("PointSize")
			Local sb:TCEScrollbar = TCEScrollbar(TCEWindowManager.getWindow("FontDemo/PointSize"))
			sb.setEnabled (b)
			
			' Set the textbox' font to have the current scale
			If font.isPropertyPresent("PointSize") Then
				font.setProperty("PointSize", (MIN_POINT_SIZE + sb.getScrollPosition()))
			End If
			
			setFontDesc()
		End If
		
		Return True
	End Function

	
	Function handleAutoScaled:Int(e:TCEEventArgs)
		Local cb:TCECheckbox = TCECheckbox(TCEWindowEventArgs(e).getWindow())
		
		Local mle:TCEMultiLineEditbox = TCEMultiLineEditbox(TCEWindowManager.getWindow("FontDemo/FontSample"))
		
		Local f:TCEFont = mle.getFont()
		f.setPropertyAsBool("AutoScaled", cb.isSelected())
		
		updateTextWindows()
		Return True
	End Function


	Function handleAntialiased:Int(e:TCEEventArgs)
		Local cb:TCECheckbox = TCECheckbox(TCEWindowEventArgs(e).getWindow())
		
		Local mle:TCEMultiLineEditbox = TCEMultiLineEditbox(TCEWindowManager.getWindow("FontDemo/FontSample"))
		
		Local f:TCEFont = mle.getFont()
		f.setPropertyAsBool("Antialiased", cb.isSelected())
		
		updateTextWindows()
		Return True
	End Function
	
	Function handlePointSize:Int(e:TCEEventArgs)
		Local sb:TCEScrollbar = TCEScrollbar(TCEWindowEventArgs(e).getWindow())
		
		Local f:TCEFont = TCEWindowManager.getWindow("FontDemo/FontSample").getFont()
		f.setProperty("PointSize", (MIN_POINT_SIZE + sb.getScrollPosition()))
		
		setFontDesc()
		
		updateTextWindows()
		Return True
	End Function

	' User selects a new language. Change the textbox content, and start with
	' the recommended font.
	Function handleLangSelection:Int(e:TCEEventArgs)
		' Access the listbox which sent the event
		Local lbox:TCEListbox = TCEListbox(TCEWindowEventArgs(e).getWindow())
		
		If lbox.getFirstSelectedItem() Then
			Local idx:Int = lbox.getItemIndex(lbox.getFirstSelectedItem())
			' Set default font to avoid initial glyph errors
			Local fontIdx:Int = 0	' Default to DejaVu Sans for the non-Asian fonts
			If idx = 4 Then	' Japanese
				fontIdx = 3
			Else If idx = 5 Then	' Korean
				fontIdx = 3
			End If
			
			' Access the font list
			Local fontList:TCEListbox = TCEListbox(TCEWindowManager.getWindow("FontDemo/FontList"))
			' Select correct font when not set already
			If Not fontList.isItemSelected(fontIdx) Then
				' This will cause 'handleFontSelection' to get called(!)
				fontList.setItemSelectStateForIndex(fontIdx, True)
			End If
			
			' Finally, set the sample text for the selected language
			TCEWindowManager.getWindow("FontDemo/FontSample").setText(LangList[idx].Text)
		End If
		
		Return True
	End Function
	
	'! Ensure window content and layout is updated.
	Function updateTextWindows()
		Local eb:TCEMultiLineEditbox = TCEMultiLineEditbox(TCEWindowManager.getWindow("FontDemo/FontSample"))
		' this is a hack to force the editbox to update it's state, and is
		' needed because no facility currently exists for a font to notify that
		' it's internal size or state has changed (ideally all affected windows
		' should receive EventFontChanged - this should be a TODO item!)
		eb.setWordWrapping(False)
		eb.setWordWrapping(True)
		' inform lists of updated data too
		Local lb:TCEListbox = TCEListbox(TCEWindowManager.getWindow("FontDemo/LangList"))
		lb.handleUpdatedItemData()
		lb = TCEListbox(TCEWindowManager.getWindow("FontDemo/FontList"))
		lb.handleUpdatedItemData()
	End Function

End Type


