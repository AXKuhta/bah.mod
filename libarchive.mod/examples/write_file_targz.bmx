'
'
'
'
SuperStrict

Framework BaH.LibArchive
Import BRL.StandardIO
Import brl.FileSystem

' get a list of files to archive
Local filelist:String[] = LoadDir("verne")


Local archive:TWriteArchive = New TWriteArchive.Create()

archive.AddFilterGzip() ' gzip
archive.SetFormatPaxRestricted() ' tar

archive.OpenFilename("verne2.tar.gz")


Local entry:TArchiveEntry = New TArchiveEntry.Create()


Local diskFile:TReadDiskArchive = New TReadDiskArchive.Create()
diskFile.SetStandardLookup()

Local buf:Byte[8192]
Local bytesRead:Long

' with each file
For Local file:String = EachIn filelist

	Local path:String = "verne/" + file

	entry.Clear()
	entry.SetPathname(path)

	' get details about file, and populate TArchiveEntry (timestamps, permissions, etc)
	diskFile.EntryFromFile(entry)
	
	' write the header
	If archive.WriteHeader(entry) Then
		Print archive.ErrorString()
		End
	End If
	
	' load the data for the archive
?bmxng
	Local stream:TStream = ReadStream(path)
?Not bmxng
	Local stream:TSStream = BaH.SStream.ReadStream(path)
?

	bytesRead = stream.Read(buf, 8192)
	
	While bytesRead
		' write into the archive
		archive.WriteData(buf, Int(bytesRead))
		
		bytesRead = stream.Read(buf, 8192)
	Wend
	
	stream.Close()
	
Next

' finally, close the archive
archive.Close()


