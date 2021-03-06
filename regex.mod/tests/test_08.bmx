' utf test...
' test for offsets working, as well as doing a replace on some utf text.
'
SuperStrict

Framework bah.regex
Import brl.systemdefault

Local strs:String[] = ["test1", "test2", "test3", "Кирилл"]
Local text:String = "Just a test1 string with test, test2, Кирилл и Мефодий test3 and of course test 4"

For Local str:String = EachIn strs
	Try
		Local regex:TRegEx = TRegEx.Create(str)
		text = regex.Replace(text, "`" + str + "`")
		regex = Null
	Catch ex:TRegExException
		Notify ex.toString()
	Catch ex:Object
		Notify ex.ToString()
	End Try
Next

' Since the "console" doesn't display utf-8 nicely, we'll chuck the output to a message box instead...
Notify text
