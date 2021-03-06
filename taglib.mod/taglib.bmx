' Copyright (c) 2009-2019 Bruce A Henderson
'
'  The contents of this file are subject to the Mozilla Public License
'  Version 1.1 (the "License"); you may not use this file except in
'  compliance with the License. You may obtain a copy of the License at
'  http://www.mozilla.org/MPL/
'  
'  Software distributed under the License is distributed on an "AS IS"
'  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
'  License for the specific language governing rights and limitations
'  under the License.
'  
'  The Original Code is BaH.TagLib.
'  
'  The Initial Developer of the Original Code is Bruce A Henderson.
'
SuperStrict

Rem
bbdoc: TagLib
about: Reading and editing audio meta data.
End Rem
Module BaH.TagLib

ModuleInfo "Version: 1.03"
ModuleInfo "License: MPL"
ModuleInfo "Copyright: TagLib - Scott Wheeler"
ModuleInfo "Copyright: Wrapper - 2009-2019 Bruce A Henderson"

ModuleInfo "History: 1.03"
ModuleInfo "History: Refactored use of 'enum'."
ModuleInfo "History: Fixed incorrectly named readOnly() method."
ModuleInfo "History: 1.02"
ModuleInfo "History: Update to TagLib 1.11.1.a800931"
ModuleInfo "History: 1.01"
ModuleInfo "History: Updated for NG."
ModuleInfo "History: 1.00"
ModuleInfo "History: Initial Release (TagLib 1.9.1)"

ModuleInfo "CC_OPTS: -DHAVE_ZLIB -DTAGLIB_STATIC"

Import "common.bmx"

'
' Build notes :
'
' Passing Strings between BlitzMax and library :
'   Strings should be converted to UTF-8 :
'          TagLib::String(the_converted_bbstring_to_utf8, TagLib::String::UTF8)
'
'   String returning from library, should be converted from utf8.
'

Rem
bbdoc: This type provides a simple abstraction for creating and handling files.
about: TTLFileRef exists to provide a minimal, generic and value-based wrapper around a File. It is lightweight and implicitly shared,
and as such suitable for pass-by-value use. This hides some of the uglier details of TagLib::File and the non-generic portions of the
concrete file implementations.
<p>
This type is useful in a "simple usage" situation where it is desirable to be able to get and set some of the tag information that is
similar across file types.
</p>
End Rem
Type TTLFileRef

	Field fileRefPtr:Byte Ptr

	Rem
	bbdoc: Creates a TTLFileRef from @filename.
	about: If @readAudioProperties is True then the audio properties will be read using @audioPropertiesStyle.
	If @readAudioProperties is False then @audioPropertiesStyle will be ignored.
	End Rem
	Function CreateFileRef:TTLFileRef(filename:String, readAudioProperties:Int = True, audioPropertiesStyle:Int = TTLAudioProperties.READSTYLE_AVERAGE)
		Return New TTLFileRef.Create(filename, readAudioProperties, audioPropertiesStyle)
	End Function

	Rem
	bbdoc: Creates a TTLFileRef from @filename.
	about: If @readAudioProperties is True then the audio properties will be read using @audioPropertiesStyle.
	If @readAudioProperties is False then @audioPropertiesStyle will be ignored.
	End Rem
	Method Create:TTLFileRef(filename:String, readAudioProperties:Int = True, audioPropertiesStyle:Int = TTLAudioProperties.READSTYLE_AVERAGE)
		fileRefPtr = bmx_taglib_fileref_create(filename, readAudioProperties, audioPropertiesStyle)
		Return Self
	End Method

	Rem
	bbdoc: Returns the file's tag.
	End Rem
	Method tag:TTLTag()
		Return TTLTag._create(bmx_taglib_fileref_tag(fileRefPtr))
	End Method
	
	Rem
	bbdoc: Returns the audio properties for this FileRef.
	about: If no audio properties were read then this will return Null.
	End Rem
	Method audioProperties:TTLAudioProperties()
		Return TTLAudioProperties._create(bmx_taglib_fileref_audioproperties(fileRefPtr))
	End Method
	
	Rem
	bbdoc: Saves the file.
	returns: True on success.
	End Rem
	Method save:Int()
		Return bmx_taglib_fileref_save(fileRefPtr)
	End Method
	
	Rem
	bbdoc: Returns true if the file (and as such other file references) are null.
	End Rem
	Method isNull:Int()
		Return bmx_taglib_fileref_isnull(fileRefPtr)
	End Method
	
	Rem
	bbdoc: Frees and closes the FileRef.
	End Rem
	Method Free()
		If fileRefPtr Then
			bmx_taglib_fileref_delete(fileRefPtr)
			fileRefPtr = Null
		End If
	End Method
	
	Method Delete()
		Free()
	End Method
	
End Type

Rem
bbdoc: A simple, generic interface to common audio meta data fields.
about: This is an attempt to abstract away the difference in the meta data formats of various audio codecs and tagging schemes.
As such it is generally a subset of what is available in the specific formats but should be suitable for most applications.
This is meant to compliment the generic APIs found in TTLAudioProperties, TTLFile and TTLFileRef.
End Rem
Type TTLTag

	Field tagPtr:Byte Ptr
	
	Function _create:TTLTag(tagPtr:Byte Ptr) { nomangle }
		If tagPtr Then
			Local this:TTLTag = New TTLTag
			this.tagPtr = tagPtr
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Returns the track name.
	about: If no track name is present in the tag Null will be returned.
	End Rem
	Method title:String()
		Return bmx_taglib_tag_title(tagPtr)
	End Method
	
	Rem
	bbdoc: Returns the artist name.
	about: If no artist name is present in the tag Null will be returned.
	End Rem
	Method artist:String()
		Return bmx_taglib_tag_artist(tagPtr)
	End Method
	
	Rem
	bbdoc: Returns the album name.
	about: If no album name is present in the tag Null will be returned.
	End Rem
	Method album:String()
		Return bmx_taglib_tag_album(tagPtr)
	End Method
	
	Rem
	bbdoc: Returns the track comment.
	about: If no comment is present in the tag Null will be returned.
	End Rem
	Method comment:String()
		Return bmx_taglib_tag_comment(tagPtr)
	End Method
	
	Rem
	bbdoc: Returns the genre name.
	about: If no genre is present in the tag Null will be returned.
	End Rem
	Method genre:String()
		Return bmx_taglib_tag_genre(tagPtr)
	End Method
	
	Rem
	bbdoc: Returns the year.
	about: If there is no year set, this will return 0.
	End Rem
	Method year:Int()
		Return bmx_taglib_tag_year(tagPtr)
	End Method
	
	Rem
	bbdoc: Returns the track number.
	about: If there is no track number set, this will return 0.
	End Rem
	Method track:Int()
		Return bmx_taglib_tag_track(tagPtr)
	End Method
	
	Rem
	bbdoc: Sets the title to @value.
	about: If @value is Null then this value will be cleared.
	End Rem
	Method setTitle(value:String)
		bmx_taglib_tag_settitle(tagPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the artist to @value.
	about: If @value is Null then this value will be cleared.
	End Rem
	Method setArtist(value:String)
		bmx_taglib_tag_setartist(tagPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the album to @value.
	about: If @value is Null then this value will be cleared.
	End Rem
	Method setAlbum(value:String)
		bmx_taglib_tag_setalbum(tagPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the comment to @value.
	about: If @value is Null then this value will be cleared.
	End Rem
	Method setComment(value:String)
		bmx_taglib_tag_setcomment(tagPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the genre to @value.
	about: If @value is Null then this value will be cleared.
	End Rem
	Method setGenre(value:String)
		bmx_taglib_tag_setgenre(tagPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the year to @value.
	about: If s is 0 then this value will be cleared.
	End Rem
	Method setYear(value:Int)
		bmx_taglib_tag_setyear(tagPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the track to @value.
	about: If s is 0 then this value will be cleared.
	End Rem
	Method setTrack(value:Int)
		bmx_taglib_tag_settrack(tagPtr, value)
	End Method
	
	Rem
	bbdoc: Returns true if the tag does not contain any data.
	End Rem
	Method isEmpty:Int()
		Return bmx_taglib_tag_isempty(tagPtr)
	End Method

	Rem
	bbdoc: Exports the tags of the file as dictionary mapping (human readable) tag names (Strings) to String[] of tag values.
	about: The default implementation in this type considers only the usual built-in tags (artist, album, ...) and only one value per key.
	End Rem
	Method properties:TTLPropertyMap()
		Return TTLPropertyMap._create(bmx_taglib_tag_properties(tagPtr))
	End Method
	
End Type

Rem
bbdoc: A map for format-independent &ltg;key,valuelist&gt; tag representations.
about: This map implements a generic representation of textual audio metadata ("tags") realized as pairs of a case-insensitive key and a nonempty
list of corresponding values, each value being an an arbitrary unicode String.
Note that most metadata formats pose additional conditions on the tag keys. The most popular ones (Vorbis, APE, ID3v2) should support all ASCII only words
of length between 2 and 16.
End Rem
Type TTLPropertyMap

	Field pmapPtr:Byte Ptr
	
	Function _create:TTLPropertyMap(pmapPtr:Byte Ptr) { nomangle }
		If pmapPtr Then
			Local this:TTLPropertyMap = New TTLPropertyMap
			this.pmapPtr = pmapPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Returns true if the map contains values for key.
	End Rem
	Method contains:Int(key:String)
		Return bmx_taglib_propertymap_contains(pmapPtr, key)
	End Method
	
	Rem
	bbdoc: Returns a list of the values associated with key.
	about: If key is not contained in the map, an empty list is returned.
	End Rem
	Method values:String[](key:String)
		Return bmx_taglib_propertymap_values(pmapPtr, key)
	End Method

	Method Free()
		If pmapPtr Then
			bmx_taglib_propertymap_free(pmapPtr)
			pmapPtr = Null
		End If
	End Method
	
	Method Delete()
		Free()
	End Method

End Type

Rem
bbdoc: A simple, abstract interface to common audio properties.
about: The values here are common to most audio formats. For more specific, codec dependant values, please see see the subclasses APIs.
This is meant to compliment the TTLFile and TTLTag APIs in providing a simple interface that is sufficient for most applications.
End Rem
Type TTLAudioProperties

	Rem
	bbdoc: Read as little of the file as possible.
	about: Reading audio properties from a file can sometimes be very time consuming and for the most accurate results can
	often involve reading the entire file. Because in many situations speed is critical or the accuracy of the values
	is not particularly important this allows the level of desired accuracy to be set.
	End Rem
	Const READSTYLE_FAST:Int = 0
	Rem
	bbdoc: Read more of the file and make better values guesses.
	about: Reading audio properties from a file can sometimes be very time consuming and for the most accurate results can
	often involve reading the entire file. Because in many situations speed is critical or the accuracy of the values
	is not particularly important this allows the level of desired accuracy to be set.
	End Rem
	Const READSTYLE_AVERAGE:Int = 1
	Rem
	bbdoc: Read as much of the file as needed to report accurate values.
	about: Reading audio properties from a file can sometimes be very time consuming and for the most accurate results can
	often involve reading the entire file. Because in many situations speed is critical or the accuracy of the values
	is not particularly important this allows the level of desired accuracy to be set.
	End Rem
	Const READSTYLE_ACCURATE:Int = 2

	Field apPtr:Byte Ptr

	Function _create:TTLAudioProperties(apPtr:Byte Ptr) { nomangle }
		If apPtr Then
			Local this:TTLAudioProperties = New TTLAudioProperties
			this.apPtr = apPtr
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Returns the length of the file in seconds.
	End Rem
	Method length:Int()
		Return bmx_taglib_audoproperties_length(apPtr)
	End Method
	
	Rem
	bbdoc: Returns the most appropriate bit rate for the file in kb/s.
	about: For constant bitrate formats this is simply the bitrate of the file. For variable bitrate formats this is either the average
	or nominal bitrate.
	End Rem
	Method bitrate:Int()
		Return bmx_taglib_audoproperties_bitrate(apPtr)
	End Method
	
	Rem
	bbdoc: Returns the sample rate in Hz.
	End Rem
	Method sampleRate:Int()
		Return bmx_taglib_audoproperties_samplerate(apPtr)
	End Method
	
	Rem
	bbdoc: Returns the number of audio channels.
	End Rem
	Method channels:Int()
		Return bmx_taglib_audoproperties_channels(apPtr)
	End Method

End Type

Rem
bbdoc: A file type with some useful methods for tag manipulation.
about: This type is a basic file type with some methods that are particularly useful for tag editors.
It has methods to take advantage of ByteVector and a binary search method for finding patterns in a file.
End Rem
Type TTLFile

	Field filePtr:Byte Ptr

	Method name:String()
	End Method
	
	Method audioProperties:TTLAudioProperties()
	End Method
	
	Method save:Int()
	End Method

	Method isOpen:Int()
	End Method

	Method isValid:Int()
	End Method
	
	Method clear()
	End Method
	
	Method length:Int()
	End Method
	
	Rem
	bbdoc: Returns true if the file is read only (or if the file can not be opened).
	End Rem
	Method isReadOnly:Int()
		Return bmx_taglib_file_readonly(filePtr)
	End Method
	
	Rem
	bbdoc: Returns True if @file can be opened for reading.
	about: If the file does not exist, this will return False.
	End Rem
	Function isReadable:Int(file:String)
		Return bmx_taglib_file_isreadable(file)
	End Function
	
	Rem
	bbdoc: Returns True if @file can be opened for writing.
	End Rem
	Function isWritable:Int(file:String)
		Return bmx_taglib_file_iswritable(file)
	End Function
	
	Rem
	bbdoc: Exports the tags of the file as dictionary mapping (human readable) tag names (Strings) to StringLists of tag values.
	about: Calls the according specialization in the File subclasses. For each metadata object of the file that could not be parsed
	into the PropertyMap format, the returend map's unsupportedData() list will contain one entry identifying that object (e.g. the frame type for ID3v2 tags). 
	End Rem
	Method properties:TTLPropertyMap()
		Return TTLPropertyMap._create(bmx_taglib_file_properties(filePtr))
	End Method

End Type

Rem
bbdoc: An MPEG file type with some useful methods specific to MPEG.
about: This implements the generic TTLFile API and additionally provides access to properties that
are distinct to MPEG files, notably access to the different ID3 tags.
End Rem
Type TTLMPEGFile Extends TTLFile

	Const TAGTYPE_NOTAGS:Int = 0
	Const TAGTYPE_ID3V1:Int = 1
	Const TAGTYPE_ID3v2:Int = 2
	Const TAGTYPE_APE:Int = 3
	Const TAGTYPE_ALLTAGS:Int = 4
	
	Rem
	bbdoc: 
	End Rem
	Function CreateMPEGFile:TTLMPEGFile(filename:String, readProperties:Int = True, propertiesStyle:Int = TTLAudioProperties.READSTYLE_AVERAGE)
		Return New TTLMPEGFile.Create(filename, readProperties, propertiesStyle)
	End Function
	
	Rem
	bbdoc: 
	End Rem
	Method Create:TTLMPEGFile(filename:String, readProperties:Int = True, propertiesStyle:Int = TTLAudioProperties.READSTYLE_AVERAGE)
		filePtr = bmx_taglib_mpegfile_create(filename, readProperties, propertiesStyle)
		Return Self
	End Method

	Rem
	bbdoc: Returns the TTLMPEGProperties for this file.
	about: If no audio properties were read then this will return Null.
	End Rem
	Method audioProperties:TTLAudioProperties()
		Return TTLMPEGProperties._create(bmx_taglib_mpegfile_audioproperties(filePtr))
	End Method
	
	Rem
	bbdoc: Saves the file.
	about: If at least one tag -- ID3v1 or ID3v2 -- exists this will duplicate its content into the other tag.
	This returns true if saving was successful.
	<p>
	If neither exists or if both tags are empty, this will strip the tags from the file.
	</p>
	<p>
	This is the same as calling save(AllTags);
	</p>
	<p>
	If you would like more granular control over the content of the tags, with the concession of generality, use paramaterized saveTags call.
	</p>
	End Rem
	Method save:Int()
		Return bmx_taglib_mpegfile_save(filePtr)
	End Method

	Rem
	bbdoc: Saves the file.
	about: This will attempt to save all of the tag types that are specified by OR-ing together TagTypes values.
	The save() method above uses AllTags. This returns true if saving was successful.
	<p>
	If stripOthers is true this strips all tags not included in the mask, but does not modify them in memory,
	so later calls to saveTags() which make use of these tags will remain valid. This also strips empty tags. 
	</p>
	End Rem
	Method saveTags:Int(tags:Int, stripOthers:Int = False)
		Return bmx_taglib_mpegfile_savetags(filePtr, tags, stripOthers)
	End Method

	Rem
	bbdoc: Returns the ID3v2 tag of the file.
	about: If @_create is false (the default) this will return Null if there is no valid ID3v2 tag.
	If @_create is true it will create an ID3v2 tag if one does not exist.
	End Rem
	Method ID3v2Tag:TTLID3v2Tag(_create:Int = False)
		Return TTLID3v2Tag._create(bmx_taglib_mpegfile_id3v2tag(filePtr, _create))
	End Method
	
	Rem
	bbdoc: Returns the ID3v1 tag of the file.
	about: A tag will always be returned, regardless of whether there is a tag in the file or not. Use Tag::isEmpty() to check if the tag contains no data.
	End Rem
	Method ID3v1Tag:TTLID3v1Tag(_create:Int = False)
		Return TTLID3v1Tag._create(bmx_taglib_mpegfile_id3v1tag(filePtr, _create))
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method APETag:TTLAPETag(_create:Int = False)
		Return TTLAPETag._create(bmx_taglib_mpegfile_apetag(filePtr, _create))
	End Method
	
	Rem
	bbdoc: This will strip the tags that match the OR-ed together TagTypes from the file.
	about: By default it strips all tags. It returns true if the tags are successfully stripped.
	<p>
	If @freeMemory is true the ID3 and APE tags will be deleted and pointers to them will be invalidated. 
	</p>
	End Rem
	Method strip:Int(tags:Int = TAGTYPE_ALLTAGS, freeMemory:Int = True)
		Return bmx_taglib_mpegfile_strip(filePtr, tags, freeMemory)
	End Method
	
	Rem
	bbdoc: Returns the position in the file of the first MPEG frame.
	End Rem
	Method firstFrameOffset:Int()
		Return bmx_taglib_mpegfile_firstframeoffset(filePtr)
	End Method
	
	Rem
	bbdoc: Returns the position in the file of the next MPEG frame, using the current position as start.
	End Rem
	Method nextFrameOffset:Int(position:Int)
		Return bmx_taglib_mpegfile_nextframeoffset(filePtr, position)
	End Method
	
	Rem
	bbdoc: Returns the position in the file of the previous MPEG frame, using the current position as start.
	End Rem
	Method previousFrameOffset:Int(position:Int)
		Return bmx_taglib_mpegfile_previousframeoffset(filePtr, position)
	End Method
	
	Rem
	bbdoc: Returns the position in the file of the last MPEG frame.
	End Rem
	Method lastFrameOffset:Int()
		Return bmx_taglib_mpegfile_lastframeoffset(filePtr)
	End Method

	Rem
	bbdoc: Since the file can currently only be opened as an argument to the constructor (sort-of by design), this returns if that open succeeded.
	End Rem
	Method isOpen:Int()
		Return bmx_taglib_mpegfile_isopen(filePtr)
	End Method

	Rem
	bbdoc: Returns true if the file is open and readble and valid information for the Tag and / or AudioProperties was found.
	End Rem
	Method isValid:Int()
		Return bmx_taglib_mpegfile_isvalid(filePtr)
	End Method
	
	Rem
	bbdoc: Resets the end-of-file and error flags on the file.
	End Rem
	Method clear()
		bmx_taglib_mpegfile_clear(filePtr)
	End Method
	
	Rem
	bbdoc: Returns the length of the file.
	End Rem
	Method length:Int()
		Return bmx_taglib_mpegfile_length(filePtr)
	End Method

	Rem
	bbdoc: Frees and closes the file.
	End Rem
	Method Free()
		If filePtr Then
			bmx_taglib_mpegfile_free(filePtr)
			filePtr = Null
		End If
	End Method
	
	Method Delete()
		Free()
	End Method
	
End Type

Rem
bbdoc: An implementation of audio property reading for MP3.
about: This reads the data from an MPEG Layer III stream found in the AudioProperties API.
End Rem
Type TTLMPEGProperties Extends TTLAudioProperties

	Function _create:TTLMPEGProperties(apPtr:Byte Ptr)  { nomangle }
		If apPtr Then
			Local this:TTLMPEGProperties = New TTLMPEGProperties
			this.apPtr = apPtr
			Return this
		End If
	End Function

	Method xingHeader:TTLMPEGXingHeader()
	' TODO
	End Method
	
	Rem
	bbdoc: Returns the MPEG Version of the file.
	End Rem
	Method version:Int()
		Return bmx_taglib_mpegproperties_version(apPtr)
	End Method
	
	Rem
	bbdoc: Returns the layer version.
	about: This will be between the values 1-3.
	End Rem
	Method layer:Int()
		Return bmx_taglib_mpegproperties_layer(apPtr)
	End Method
	
	Rem
	bbdoc: Returns true if the MPEG protection bit is enabled.
	End Rem
	Method protectionEnabled:Int()
		Return bmx_taglib_mpegproperties_protectionenabled(apPtr)
	End Method
	
	Rem
	bbdoc: Returns the channel mode for this frame.
	End Rem
	Method channelMode:Int()
		Return bmx_taglib_mpegproperties_channelmode(apPtr)
	End Method
	
	Rem
	bbdoc: Returns true if the copyrighted bit is set.
	End Rem
	Method isCopyrighted:Int()
		Return bmx_taglib_mpegproperties_iscopyrighted(apPtr)
	End Method
	
	Rem
	bbdoc: Returns true if the "original" bit is set.
	End Rem
	Method isOriginal:Int()
		Return bmx_taglib_mpegproperties_isoriginal(apPtr)
	End Method
	
End Type

Type TTLMPEGXingHeader

End Type

Rem
bbdoc: An implementation of TagLib::File with FLAC specific methods.
about: This implements and provides an interface for FLAC files to the TagLib::Tag and TagLib::AudioProperties interfaces by way of
implementing the abstract TagLib::File API as well as providing some additional information specific to FLAC files.
End Rem
Type TTLFLACFile Extends TTLFile

	Rem
	bbdoc: Contructs a FLAC file from @filename.
	about: If readProperties is true the file's audio properties will also be read using propertiesStyle. If false, propertiesStyle is ignored.
	End Rem
	Function CreateFLACFile:TTLFLACFile(filename:String, readProperties:Int = True, propertiesStyle:Int = TTLAudioProperties.READSTYLE_AVERAGE)
		Return New TTLFLACFile.Create(filename, readProperties, propertiesStyle)
	End Function
	
	Rem
	bbdoc: Contructs a FLAC file from @filename.
	about: If readProperties is true the file's audio properties will also be read using propertiesStyle. If false, propertiesStyle is ignored.
	End Rem
	Method Create:TTLFLACFile(filename:String, readProperties:Int = True, propertiesStyle:Int = TTLAudioProperties.READSTYLE_AVERAGE)
		filePtr = bmx_taglib_flacfile_create(filename, readProperties, propertiesStyle)
		Return Self
	End Method

	Rem
	bbdoc: Returns the TTLFLACProperties for this file.
	about: If no audio properties were read then this will return Null.
	End Rem
	Method audioProperties:TTLAudioProperties()
		Return TTLFLACProperties._create(bmx_taglib_flacfile_audioproperties(filePtr))
	End Method
	
	Rem
	bbdoc: Save the file.
	returns: True if the save was successful.
	about: This will primarily save the XiphComment, but will also keep any old ID3-tags up to date. If the file has no XiphComment, one will be constructed from the ID3-tags.
	End Rem
	Method save:Int()
		Return bmx_taglib_flacfile_save(filePtr)
	End Method

	Rem
	bbdoc: Returns the ID3v2 tag of the file.
	about: If @_create is false (the default) this will return Null if there is no valid ID3v2 tag.
	If @_create is true it will create an ID3v2 tag if one does not exist.
	End Rem
	Method ID3v2Tag:TTLID3v2Tag(_create:Int = False)
		Return TTLID3v2Tag._create(bmx_taglib_flacfile_id3v2tag(filePtr, _create))
	End Method
	
	Rem
	bbdoc: Returns the ID3v1 tag of the file.
	about: If @_create is false (the default) this will return Null if there is no valid ID3v1 tag.
	If @_create is true it will create an ID3v1 tag if one does not exist.
	End Rem
	Method ID3v1Tag:TTLID3v1Tag(_create:Int = False)
		Return TTLID3v1Tag._create(bmx_taglib_flacfile_id3v1tag(filePtr, _create))
	End Method

	Rem
	bbdoc: Returns a list of pictures attached to the FLAC file.
	End Rem
	Method pictureList:TTLFLACPictureList()
		Return TTLFLACPictureList._create(bmx_taglib_flacfile_picturelist(filePtr))
	End Method
	
	Rem
	bbdoc: Remove all attached images.
	End Rem
	Method removePictures()
		bmx_taglib_flacfile_removepictures(filePtr)
	End Method
	
	Rem
	bbdoc: Add a new picture to the file.
	about: The file takes ownership of the picture and will handle freeing its memory.
	<p>Note: The file will be saved only after calling save().</p>
	End Rem
	Method addPicture(picture:TTLFLACPicture)
		bmx_taglib_flacfile_addpicture(filePtr, picture.picturePtr)
	End Method
	
	Rem
	bbdoc: Returns the TTLOggXiphComment for the file.
	about: If @_create is false (the default) this will return a null pointer if there is no valid TTLOggXiphComment.
	If @_create is true it will create a TTLOggXiphComment if one does not exist.
	End Rem
	Method xiphComment:TTLOggXiphComment(_create:Int = False)
		Return TTLOggXiphComment._create(bmx_taglib_flacfile_xiphcomment(filePtr, _create))
	End Method
	
	Rem
	bbdoc: Frees and closes the file.
	End Rem
	Method Free()
		If filePtr Then
			bmx_taglib_flacfile_free(filePtr)
			filePtr = Null
		End If
	End Method
	
	Method Delete()
		Free()
	End Method

End Type

Rem
bbdoc: An implementation of audio property reading for FLAC.
about: This reads the data from an FLAC stream found in the AudioProperties API.
End Rem
Type TTLFLACProperties Extends TTLAudioProperties

	Function _create:TTLFLACProperties(apPtr:Byte Ptr) { nomangle }
		If apPtr Then
			Local this:TTLFLACProperties = New TTLFLACProperties
			this.apPtr = apPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Returns the sample width as read from the FLAC identification header.
	End Rem
	Method sampleWidth:Int()
		Return bmx_taglib_flacproperties_samplewidth(apPtr)
	End Method
	
	Rem
	bbdoc: Returns the number of sample frames.
	End Rem
	Method sampleFrames:Long()
		Local frames:Long
		bmx_taglib_flacproperties_sampleframes(apPtr, Varptr frames)
		Return frames
	End Method
	
	Rem
	bdoc: Returns the MD5 signature of the uncompressed audio stream as read from the stream info header header.
	End Rem
	Method signature:TTLByteVector()
		Return TTLByteVector._create(bmx_taglib_flacproperties_signature(apPtr))
	End Method
	
End Type

Rem
bbdoc: 
End Rem
Type TTLFLACPictureList

	Field pictureListPtr:Byte Ptr

	Function _create:TTLFLACPictureList(pictureListPtr:Byte Ptr) { nomangle }
		If pictureListPtr Then
			Local this:TTLFLACPictureList = New TTLFLACPictureList
			this.pictureListPtr = pictureListPtr
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Returns the picture at the specified index.
	End Rem
	Method picture:TTLFLACPicture(index:Int)
		Return TTLFLACPicture(bmx_taglib_flacpicturelist_picture(pictureListPtr, index))
	End Method
	
	Rem
	bbdoc: Returns True if the list is empty.
	End Rem
	Method isEmpty:Int()
		Return bmx_taglib_flacpicturelist_isempty(pictureListPtr)
	End Method
	
	Rem
	bbdoc: Returns the size of the list.
	End Rem
	Method size:Int()
		Return bmx_taglib_flacpicturelist_size(pictureListPtr)
	End Method

	Method ObjectEnumerator:TTLFLACPictureListEnumerator()
		' Reset the iterator
		bmx_taglib_flacpicturelist_reset(pictureListPtr)
	
		Local enum:TTLFLACPictureListEnumerator = New TTLFLACPictureListEnumerator
		enum.list = Self
		Return enum
	End Method

	Method Delete()
		If pictureListPtr Then
			bmx_taglib_flacpicturelist_free(pictureListPtr)
			pictureListPtr = Null
		End If
	End Method
	
End Type

' internal support for EachIn
Type TTLFLACPictureListEnumerator
	Field list:TTLFLACPictureList
	Field nextItem:TTLFLACPicture

	Method HasNext:Int()
		If Not nextItem Then
			nextItem = TTLFLACPicture(bmx_taglib_flacpicturelist_nextitem(list.pictureListPtr))
		End If
		
		If nextItem Then
			Return True
		End If
	End Method
	
	Method NextObject:Object()
		Local tmpItem:TTLFLACPicture = nextItem
		nextItem = Null
		Return tmpItem
	End Method
End Type

Rem
bbdoc: A FLAC embedded picture.
End Rem
Type TTLFLACPicture

	Field picturePtr:Byte Ptr

	Rem
	bbdoc: A type not enumerated.
	End Rem
	Const TYPE_OTHER:Int = $00
	Rem
	bbdoc: 32x32 PNG image that should be used as the file icon
	End Rem
	Const TYPE_FILEICON:Int = $01
	Rem
	bbdoc: File icon of a different size or format.
	End Rem
	Const TYPE_OTHERFILEICON:Int = $02
	Rem
	bbdoc: Front cover image of the album.
	End Rem
	Const TYPE_FRONTCOVER:Int = $03
	Rem
	bbdoc: Back cover image of the album.
	End Rem
	Const TYPE_BACKCOVER:Int = $04
	Rem
	bbdoc: Inside leaflet page of the album.
	End Rem
	Const TYPE_LEAFLETPAGE:Int = $05
	Rem
	bbdoc: Image from the album itself.
	End Rem
	Const TYPE_MEDIA:Int = $06
	Rem
	bbdoc: Picture of the lead artist or soloist.
	End Rem
	Const TYPE_LEADARTIST:Int = $07
	Rem
	bbdoc: Picture of the artist or performer.
	End Rem
	Const TYPE_ARTIST:Int = $08
	Rem
	bbdoc: Picture of the conductor.
	End Rem
	Const TYPE_CONDUCTOR:Int = $09
	Rem
	bbdoc: Picture of the band or orchestra.
	End Rem
	Const TYPE_BAND:Int = $0A
	Rem
	bbdoc: Picture of the composer.
	End Rem
	Const TYPE_COMPOSER:Int = $0B
	Rem
	bbdoc: Picture of the lyricist or text writer.
	End Rem
	Const TYPE_LYRICIST:Int = $0C
	Rem
	bbdoc: Picture of the recording location or studio.
	End Rem
	Const TYPE_RECORDINGLOCATION:Int = $0D
	Rem
	bbdoc: Picture of the artists during recording.
	End Rem
	Const TYPE_DURINGRECORDING:Int = $0E
	Rem
	bbdoc: Picture of the artists during performance.
	End Rem
	Const TYPE_DURINGPERFORMANCE:Int = $0F
	Rem
	bbdoc: Picture from a movie or video related to the track.
	End Rem
	Const TYPE_MOVIESCREENCAPTURE:Int = $10
	Rem
	bbdoc: Picture of a large, coloured fish.
	End Rem
	Const TYPE_COLOUREDFISH:Int = $11
	Rem
	bbdoc: Illustration related to the track.
	End Rem
	Const TYPE_ILLUSTRATION:Int = $12
	Rem
	bbdoc: Logo of the band or performer.
	End Rem
	Const TYPE_BANDLOGO:Int = $13
	Rem
	bbdoc: Logo of the publisher (record company).
	End Rem
	Const TYPE_PUBLISHERLOGO:Int = $14

	Function _create:TTLFLACPicture(picturePtr:Byte Ptr) { nomangle }
		If picturePtr Then
			Local this:TTLFLACPicture = New TTLFLACPicture
			this.picturePtr = picturePtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Returns the color depth (in bits-per-pixel) of the image.
	End Rem
	Method colorDepth:Int()
		Return bmx_taglib_flacpicture_colordepth(picturePtr)
	End Method
	
	Rem
	bbdoc: Returns the image data.
	End Rem
	Method data:TTLByteVector()
		Return TTLByteVector._create(bmx_taglib_flacpicture_data(picturePtr))
	End Method
	
	Rem
	bbdoc: Returns a text description of the image.
	End Rem
	Method description:String()
		Return bmx_taglib_flacpicture_description(picturePtr)
	End Method
	
	Rem
	bbdoc: Returns the height of the image.
	End Rem
	Method height:Int()
		Return bmx_taglib_flacpicture_height(picturePtr)
	End Method
	
	Rem
	bbdoc: Returns the mime type of the image.
	about: This should in most cases be "image/png" or "image/jpeg".
	End Rem
	Method mimeType:String()
		Return bmx_taglib_flacpicture_mimetype(picturePtr)
	End Method
	
	Rem
	bbdoc: Returns the number of colors used on the image.
	End Rem
	Method numColors:Int()
		Return bmx_taglib_flacpicture_numcolors(picturePtr)
	End Method
	
	Rem
	bbdoc: Sets the color depth (in bits-per-pixel) of the image.
	End Rem
	Method setColorDepth(depth:Int)
		bmx_taglib_flacpicture_setcolordepth(picturePtr, depth)
	End Method
	
	Rem
	bbdoc: Sets the image data.
	End Rem
	Method setData(data:TTLByteVector)
		bmx_taglib_flacpicture_setdata(picturePtr, data.bvPtr)
	End Method
	
	Rem
	bbdoc: Sets a textual description of the image to @desc.
	End Rem
	Method setDescription(desc:String)
		bmx_taglib_flacpicture_setdescription(picturePtr, desc)
	End Method
	
	Rem
	bbdoc: Sets the height of the image.
	End Rem
	Method setHeight(height:Int)
		bmx_taglib_flacpicture_setheight(picturePtr, height)
	End Method
	
	Rem
	bbdoc: Sets the mime type of the image.
	about: This should in most cases be "image/png" or "image/jpeg".
	End Rem
	Method setMimeType(mimeType:String)
		bmx_taglib_flacpicture_setmimetype(picturePtr, mimeType)
	End Method
	
	Rem
	bbdoc: Sets the number of colors used on the image (for indexed images).
	End Rem
	Method setNumColors(numColors:Int)
		bmx_taglib_flacpicture_setnumcolors(picturePtr, numColors)
	End Method
	
	Rem
	bbdoc: Sets the type of the image.
	End Rem
	Method setType(pictureType:Int)
		bmx_taglib_flacpicture_settype(picturePtr, pictureType)
	End Method
	
	Rem
	bbdoc: Sets the width of the image.
	End Rem
	Method setWidth(w:Int)
		bmx_taglib_flacpicture_setwidth(picturePtr, w)
	End Method
	
	Rem
	bbdoc: Returns the type of the image.
	End Rem
	Method pictureType:Int()
		Return bmx_taglib_flacpicture_picturetype(picturePtr)
	End Method
	
	Rem
	bbdoc: Returns the width of the image.
	End Rem
	Method width:Int()
		Return bmx_taglib_flacpicture_width(picturePtr)
	End Method
	
End Type

Type TTLMPCFile Extends TTLFile
End Type

Type TTLOggPageHeader
End Type

Type TTLOggFile Extends TTLFile

	Method firstPageHeader:TTLOggPageHeader()
	End Method
	
	Method lastPageHeader:TTLOggPageHeader()
	End Method
	
	
End Type

Type TTLOggFLACFile Extends TTLOggFile
End Type

Type TTLOggSpeexFile Extends TTLOggFile
End Type

Type TTLOggOpusFile Extends TTLOggFile
End Type

Rem
bbdoc: 
End Rem
Type TTLOggVorbisFile Extends TTLOggFile

	Rem
	bbdoc: 
	End Rem
	Function CreateMPEGFile:TTLOggVorbisFile(filename:String, readProperties:Int = True, propertiesStyle:Int = TTLAudioProperties.READSTYLE_AVERAGE)
		Return New TTLOggVorbisFile.Create(filename, readProperties, propertiesStyle)
	End Function
	
	Rem
	bbdoc: 
	End Rem
	Method Create:TTLOggVorbisFile(filename:String, readProperties:Int = True, propertiesStyle:Int = TTLAudioProperties.READSTYLE_AVERAGE)
		filePtr = bmx_taglib_oggvorbisfile_create(filename, readProperties, propertiesStyle)
		Return Self
	End Method

	Rem
	bbdoc: Returns the #TTLOggXiphComment for this file. 
	End Rem
	Method tag:TTLOggXiphComment()
		Return TTLOggXiphComment._create(bmx_taglib_oggvorbisfile_tag(filePtr))
	End Method
	
	Rem
	bbdoc: Returns the TTLAudioProperties for this file.
	about: If no audio properties were read then this will return null.
	End Rem
	Method audioProperties:TTLAudioProperties()
		Return TTLVorbisProperties._create(bmx_taglib_oggvorbisfile_audioproperties(filePtr))
	End Method

	Rem
	bbdoc: Saves the file and its associated tags. 
	returns: True if the save succeeds.
	about: 
	End Rem
	Method save:Int()
		Return bmx_taglib_oggvorbisfile_save(filePtr)
	End Method

	Rem
	bbdoc: Frees and closes the file.
	End Rem
	Method Free()
		If filePtr Then
			bmx_taglib_oggvorbisfile_free(filePtr)
			filePtr = Null
		End If
	End Method
	
	Method Delete()
		Free()
	End Method

End Type

Rem
bbdoc: Ogg Vorbis comment implementation. 
about: An implementation of the Ogg Vorbis comment specification, to be found in section 5 of the Ogg Vorbis specification.
Because this format is also used in other (currently unsupported) Xiph.org formats, it has been made part of a generic implementation rather
than being limited to strictly Vorbis.
<p>
Vorbis comments are a simple vector of keys and values, called fields. Multiple values for a given key are supported.
</p>
End Rem
Type TTLOggXiphComment Extends TTLTag

	Function _create:TTLOggXiphComment(tagPtr:Byte Ptr) { nomangle }
		If tagPtr Then
			Local this:TTLOggXiphComment = New TTLOggXiphComment
			this.tagPtr = tagPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Returns the number of fields present in the comment.
	End Rem
	Method fieldCount:Int()
		Return bmx_taglib_oggxiphcomment_fieldcount(tagPtr)
	End Method
	
	Rem
	bbdoc: Returns a reference to the map of field lists.
	about: Because Xiph comments support multiple fields with the same key, a pure Map would not work.
	As such this is a Map of string lists, keyed on the comment field name.
	<p>
	The standard set of Xiph/Vorbis fields (which may or may not be contained in any specific comment) is:
	</p>
	<ul>
	<li><b> TITLE </b> : Track/Work name </li>
	<li><b> VERSION </b> : The version field may be used to differentiate multiple versions of the same track title in a single collection. (e.g. remix info)</li>
	<li><b> ALBUM </b> : The collection name to which this track belongs</li>
	<li><b> TRACKNUMBER </b> : The track number of this piece if part of a specific larger collection or album </li>
	<li><b> ARTIST </b> : The artist generally considered responsible for the work. In popular music this is usually the performing band or singer. For classical music it would be the composer. For an audio book it would be the author of the original text.</li>
	<li><b> PERFORMER </b> : The artist(s) who performed the work. In classical music this would be the conductor, orchestra, soloists. In an audio book it would be the actor who did the reading. In popular music this is typically the same as the ARTIST and is omitted.</li>
	<li><b> COPYRIGHT </b> : Copyright attribution, e.g., '2001 Nobody's Band' or '1999 Jack Moffitt'</li>
	<li><b> LICENSE </b> : License information, eg, 'All Rights Reserved', 'Any Use Permitted', a URL to a license such as a Creative Commons license ("www.creativecommons.org/blahblah/license.html") or the EFF Open Audio License ('distributed under the terms of the Open Audio License. see http://www.eff.org/IP/Open_licenses/eff_oal.html for details'), etc.</li>
	<li><b> ORGANIZATION </b> : Name of the organization producing the track (i.e. the 'record label')</li>
	<li><b> DESCRIPTION </b> : A short text description of the contents</li>
	<li><b> GENRE </b> : A short text indication of music genre</li>
	<li><b> DATE </b> : Date the track was recorded</li>
	<li><b> LOCATION </b> : Location where track was recorded</li>
	<li><b> CONTACT </b> : Contact information for the creators or distributors of the track. This could be a URL, an email address, the physical address of the producing label.</li>
	<li><b> ISRC </b> : International Standard Recording Code for the track; see the <a href="http://www.ifpi.org/content/section_resources/isrc.html">ISRC intro</a> page for more information on ISRC numbers.</li>
	</ul>
	<p>
	Note: The Ogg Vorbis comment specification does allow these key values to be either upper or lower case. However, it is conventional for them
	to be upper case. As such, TagLib, when parsing a Xiph/Vorbis comment, converts all fields to uppercase. When you are using this data structure,
	you will need to specify the field name in upper case.
	</p>
	<p>
	Warning: You should not modify this data structure directly, instead use addField() and removeField().
	</p>
	End Rem
	Method fieldListMap:TTLOggFieldListMap()
		Return TTLOggFieldListMap._create(bmx_taglib_oggxiphcomment_fieldlistmap(tagPtr))
	End Method
	
	Rem
	bbdoc: Returns the vendor ID of the Ogg Vorbis encoder.
	about: libvorbis 1.0 as the most common case always returns "Xiph.Org libVorbis I 20020717".
	End Rem
	Method vendorID:String()
		Return bmx_taglib_oggxiphcomment_vendorid(tagPtr)
	End Method
	
	Rem
	bbdoc: Add the field specified by @key with the data @value.
	about: If @_replace is True, then all of the other fields with the same key will be removed first.
	If the field @value is empty, the field will be removed.
	End Rem
	Method addField(key:String, value:String, _replace:Int = True)
		bmx_taglib_oggxiphcomment_addfield(tagPtr, key, value, _replace)
	End Method
	
	Rem
	bbdoc: Remove the field specified by @key with the data @value.
	about: If @value is null, all of the fields with the given key will be removed.
	End Rem
	Method removeField(key:String, value:String = Null)
		bmx_taglib_oggxiphcomment_removefield(tagPtr, key, value)
	End Method
	
	Rem
	bbdoc: Returns true if the field is contained within the comment.
	about: Note: This is safer than checking for membership in the TTLOggFieldListMap.
	End Rem
	Method contains:Int(key:String)
		Return bmx_taglib_oggxiphcomment_contains(tagPtr, key)
	End Method
	
End Type

Rem
bbdoc: 
End Rem
Type TTLOggFieldListMap

	Field fieldListPtr:Byte Ptr
	
	Function _create:TTLOggFieldListMap(fieldListPtr:Byte Ptr) { nomangle }
		If fieldListPtr Then
			Local this:TTLOggFieldListMap = New TTLOggFieldListMap
			this.fieldListPtr = fieldListPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Returns the field for the specified key.
	End Rem
	Method getField:String[](key:String)
		Return bmx_taglib_oggfieldlistmap_field(fieldListPtr, key)
	End Method
	
	Rem
	bbdoc: Returns True if the list is empty.
	End Rem
	Method isEmpty:Int()
		Return bmx_taglib_oggfieldlistmap_isempty(fieldListPtr)
	End Method
	
	Rem
	bbdoc: Returns the size of the list.
	End Rem
	Method size:Int()
		Return bmx_taglib_oggfieldlistmap_size(fieldListPtr)
	End Method

	Method ObjectEnumerator:TTLOggFieldListMapEnumerator()
		' Reset the iterator
		bmx_taglib_oggfieldlistmap_reset(fieldListPtr)
	
		Local enum:TTLOggFieldListMapEnumerator = New TTLOggFieldListMapEnumerator
		enum.list = Self
		Return enum
	End Method

	Method Delete()
		If fieldListPtr Then
			bmx_taglib_oggfieldlistmap_free(fieldListPtr)
			fieldListPtr = Null
		End If
	End Method

End Type

' internal support for EachIn
Type TTLOggFieldListMapEnumerator
	Field list:TTLOggFieldListMap
	Field nextField:String[]

	Method HasNext:Int()
		If Not nextField Then
			nextField = bmx_taglib_oggfieldlistmap_nextfield(list.fieldListPtr)
		End If
		
		If nextField Then
			Return True
		End If
	End Method
	
	Method NextObject:Object()
		Local tmpList:String[] = nextField
		nextField = Null
		Return tmpList
	End Method
End Type

Rem
bbdoc: An implementation of audio property reading for Ogg Vorbis.
about: This reads the data from an Ogg Vorbis stream found in the AudioProperties API. 
End Rem
Type TTLVorbisProperties Extends TTLAudioProperties

	Function _create:TTLVorbisProperties(apPtr:Byte Ptr) { nomangle }
		If apPtr Then
			Local this:TTLVorbisProperties = New TTLVorbisProperties
			this.apPtr = apPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Returns the Vorbis version, currently "0" (as specified by the spec). 
	End Rem
	Method vorbisVersion:Int()
		Return bmx_taglib_vorbisproperties_vorbisversion(apPtr)
	End Method
	
	Rem
	bbdoc: Returns the maximum bitrate as read from the Vorbis identification header. 
	End Rem
	Method bitrateMaximum:Int()
		Return bmx_taglib_vorbisproperties_bitratemaximum(apPtr)
	End Method
	
	Rem
	bbdoc: Returns the nominal bitrate as read from the Vorbis identification header.
	End Rem
	Method bitrateNominal:Int()
		Return bmx_taglib_vorbisproperties_bitratenominal(apPtr)
	End Method
	
	Rem
	bbdoc: Returns the minimum bitrate as read from the Vorbis identification header. 
	End Rem
	Method bitrateMinimum:Int()
		Return bmx_taglib_vorbisproperties_bitrateminimum(apPtr)
	End Method
	
End Type

Type TTLTrueAudioFile Extends TTLFile
End Type

Type TTLWavPackFile Extends TTLFile
End Type

Rem
bbdoc: This implements and provides an interface for MP4 files.
End Rem
Type TTLMP4File Extends TTLFile

	Rem
	bbdoc: 
	End Rem
	Function CreateMP4File:TTLMP4File(filename:String, readProperties:Int = True, propertiesStyle:Int = TTLAudioProperties.READSTYLE_AVERAGE)
		Return New TTLMP4File.Create(filename, readProperties, propertiesStyle)
	End Function
	
	Rem
	bbdoc: 
	End Rem
	Method Create:TTLMP4File(filename:String, readProperties:Int = True, propertiesStyle:Int = TTLAudioProperties.READSTYLE_AVERAGE)
		filePtr = bmx_taglib_mp4file_create(filename, readProperties, propertiesStyle)
		Return Self
	End Method

	Rem
	bbdoc: Returns the TTLMPEGProperties for this file.
	about: If no audio properties were read then this will return Null.
	End Rem
	Method audioProperties:TTLAudioProperties()
		Return TTLMP4Properties._create(bmx_taglib_mp4file_audioproperties(filePtr))
	End Method
	
	Rem
	bbdoc: Saves the file.
	about: If at least one tag -- ID3v1 or ID3v2 -- exists this will duplicate its content into the other tag.
	This returns true if saving was successful.
	<p>
	If neither exists or if both tags are empty, this will strip the tags from the file.
	</p>
	<p>
	This is the same as calling save(AllTags);
	</p>
	<p>
	If you would like more granular control over the content of the tags, with the concession of generality, use paramaterized saveTags call.
	</p>
	End Rem
	Method save:Int()
		Return bmx_taglib_mp4file_save(filePtr)
	End Method

	Rem
	bbdoc: Returns the tag for the file.
	End Rem
	Method tag:TTLMP4Tag()
		Return TTLMP4Tag._create(bmx_taglib_mp4file_tag(filePtr))
	End Method

	Rem
	bbdoc: Since the file can currently only be opened as an argument to the constructor (sort-of by design), this returns if that open succeeded.
	End Rem
	Method isOpen:Int()
		Return bmx_taglib_mp4file_isopen(filePtr)
	End Method

	Rem
	bbdoc: Returns true if the file is open and readble and valid information for the Tag and / or AudioProperties was found.
	End Rem
	Method isValid:Int()
		Return bmx_taglib_mp4file_isvalid(filePtr)
	End Method
	
	Rem
	bbdoc: Resets the end-of-file and error flags on the file.
	End Rem
	Method clear()
		bmx_taglib_mp4file_clear(filePtr)
	End Method
	
	Rem
	bbdoc: Returns the length of the file.
	End Rem
	Method length:Int()
		Return bmx_taglib_mp4file_length(filePtr)
	End Method

	Rem
	bbdoc: Frees and closes the file.
	End Rem
	Method Free()
		If filePtr Then
			bmx_taglib_mp4file_free(filePtr)
			filePtr = Null
		End If
	End Method
	
	Method Delete()
		Free()
	End Method
	
End Type

Rem
bbdoc: An implementation of MP4 audio properties.
End Rem
Type TTLMP4Properties Extends TTLAudioProperties

	Function _create:TTLMP4Properties(apPtr:Byte Ptr) { nomangle }
		If apPtr Then
			Local this:TTLMP4Properties = New TTLMP4Properties
			this.apPtr = apPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: 
	End Rem
	Method bitsPerSample:Int()
		Return bmx_taglib_mp4properties_bitspersample(apPtr)
	End Method
	
End Type


Rem
bbdoc: 
End Rem
Type TTLMP4Tag Extends TTLTag

	Function _create:TTLMP4Tag(tagPtr:Byte Ptr) { nomangle }
		If tagPtr Then
			Local this:TTLMP4Tag = New TTLMP4Tag
			this.tagPtr = tagPtr
			Return this
		End If
	End Function

	Method itemList:TTLMP4ItemListMap()
		Return TTLMP4ItemListMap._create(bmx_taglib_mp4tag_itemlist(tagPtr))
	End Method

End Type

Rem
bbdoc: 
End Rem
Type TTLMP4ItemListMap

	Field itemListPtr:Byte Ptr
	
	Function _create:TTLMP4ItemListMap(itemListPtr:Byte Ptr) { nomangle }
		If itemListPtr Then
			Local this:TTLMP4ItemListMap = New TTLMP4ItemListMap
			this.itemListPtr = itemListPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Returns the item for the specified key.
	End Rem
	Method item:TTLMP4Item(key:String)
		Return TTLMP4Item(bmx_taglib_mp4itemlistmap_item(itemListPtr, key))
	End Method
	
	Rem
	bbdoc: Returns True if the list is empty.
	End Rem
	Method isEmpty:Int()
		Return bmx_taglib_mp4itemlistmap_isempty(itemListPtr)
	End Method
	
	Rem
	bbdoc: Returns the size of the list.
	End Rem
	Method size:Int()
		Return bmx_taglib_mp4itemlistmap_size(itemListPtr)
	End Method

	Method ObjectEnumerator:TTLMP4ItemListMapEnumerator()
		' Reset the iterator
		bmx_taglib_mp4itemlistmap_reset(itemListPtr)
	
		Local enum:TTLMP4ItemListMapEnumerator = New TTLMP4ItemListMapEnumerator
		enum.list = Self
		Return enum
	End Method

	Method Delete()
		If itemListPtr Then
			bmx_taglib_mp4itemlistmap_free(itemListPtr)
			itemListPtr = Null
		End If
	End Method
	
End Type

' internal support for EachIn
Type TTLMP4ItemListMapEnumerator
	Field list:TTLMP4ItemListMap
	Field nextItem:TTLMP4Item

	Method HasNext:Int()
		If Not nextItem Then
			nextItem = TTLMP4Item(bmx_taglib_mp4itemlistmap_nextitem(list.itemListPtr))
		End If
		
		If nextItem Then
			Return True
		End If
	End Method
	
	Method NextObject:Object()
		Local tmpItem:TTLMP4Item = nextItem
		nextItem = Null
		Return tmpItem
	End Method
End Type

Rem
bbdoc: 
End Rem
Type TTLMP4CoverArt

	Field coverArtPtr:Byte Ptr
	
	Function _create:TTLMP4CoverArt(coverArtPtr:Byte Ptr) { nomangle }
		If coverArtPtr Then
			Local this:TTLMP4CoverArt = New TTLMP4CoverArt
			this.coverArtPtr = coverArtPtr
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Format of the image.
	End Rem
	Method format:Int()
		Return bmx_taglib_mp4coverart_format(coverArtPtr)
	End Method
	
	Rem
	bbdoc: The image data.
	End Rem
	Method data:TTLByteVector()
		Return TTLByteVector._create(bmx_taglib_mp4coverart_data(coverArtPtr))
	End Method
	
End Type

Rem
bbdoc: 
End Rem
Type TTLMP4CoverArtList

	Field coverArtListPtr:Byte Ptr

	Function _create:TTLMP4CoverArtList(coverArtListPtr:Byte Ptr) { nomangle }
		If coverArtListPtr Then
			Local this:TTLMP4CoverArtList = New TTLMP4CoverArtList
			this.coverArtListPtr = coverArtListPtr
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Returns the frame at the specified index.
	End Rem
	Method coverArt:TTLMP4CoverArt(index:Int)
		Return TTLMP4CoverArt(bmx_taglib_mp4coverartlist_coverart(coverArtListPtr, index))
	End Method
	
	Rem
	bbdoc: Returns True if the list is empty.
	End Rem
	Method isEmpty:Int()
		Return bmx_taglib_mp4coverartlist_isempty(coverArtListPtr)
	End Method
	
	Rem
	bbdoc: Returns the size of the list.
	End Rem
	Method size:Int()
		Return bmx_taglib_mp4coverartlist_size(coverArtListPtr)
	End Method

	Method ObjectEnumerator:TTLMP4CoverArtListEnumerator()
		' Reset the iterator
		bmx_taglib_mp4coverartlist_reset(coverArtListPtr)
	
		Local enum:TTLMP4CoverArtListEnumerator = New TTLMP4CoverArtListEnumerator
		enum.list = Self
		Return enum
	End Method

	Method Delete()
		If coverArtListPtr Then
			bmx_taglib_mp4coverartlist_free(coverArtListPtr)
			coverArtListPtr = Null
		End If
	End Method
	
End Type

' internal support for EachIn
Type TTLMP4CoverArtListEnumerator
	Field list:TTLMP4CoverArtList
	Field nextItem:TTLMP4CoverArt

	Method HasNext:Int()
		If Not nextItem Then
			nextItem = TTLMP4CoverArt(bmx_taglib_mp4coverartlist_nextitem(list.coverArtListPtr))
		End If
		
		If nextItem Then
			Return True
		End If
	End Method
	
	Method NextObject:Object()
		Local tmpItem:TTLMP4CoverArt = nextItem
		nextItem = Null
		Return tmpItem
	End Method
End Type


Rem
bbdoc: An implementation of MP4 items.
End Rem
Type TTLMP4Item

	Field itemPtr:Byte Ptr
	
	Function _create:TTLMP4Item(itemPtr:Byte Ptr) { nomangle }
		If itemPtr Then
			Local this:TTLMP4Item = New TTLMP4Item
			this.itemPtr = itemPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: 
	End Rem
	Method toInt:Int()
		Return bmx_taglib_mp4item_toint(itemPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method toBool:Int()
		Return bmx_taglib_mp4item_tobool(itemPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method toIntPair(_first:Int Var, _second:Int Var)
		bmx_taglib_mp4item_tointpair(itemPtr, Varptr _first, Varptr _second)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method toStrings:String[]()
		Return bmx_taglib_mp4item_tostrings(itemPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method toCoverArtList:TTLMP4CoverArtList()
		Return TTLMP4CoverArtList._create(bmx_taglib_mp4item_coverartlist(itemPtr))
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method isValid:Int()
		Return bmx_taglib_mp4item_isvalid(itemPtr)
	End Method

End Type

Rem
bbdoc: The main type in the ID3v2 implementation.
about: ID3v2 tags have several parts, TagLib attempts to provide an interface for them all.
header(), footer() and extendedHeader() corespond to those data structures in the ID3v2 standard and the APIs for the types that they
return attempt to reflect this.
<p>
Also ID3v2 tags are built up from a list of frames, which are in turn have a header and a list of fields. TagLib provides two ways of
accessing the list of frames that are in a given ID3v2 tag. The first is simply via the frameList() method. This is just a list of references
to the frames. The second is a map from the frame type -- i.e. "COMM" for comments -- and a list of frames of that type. (In some cases
ID3v2 allows for multiple frames of the same type, hence this being a map to a list rather than just a map to an individual frame.)
</p>
<p>
More information on the structure of frames can be found in the #TTLID3v2Frame type.
</p>
End Rem
Type TTLID3v2Tag Extends TTLTag

	Function _create:TTLID3v2Tag(tagPtr:Byte Ptr) { nomangle }
		If tagPtr Then
			Local this:TTLID3v2Tag = New TTLID3v2Tag
			this.tagPtr = tagPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Returns the tag's header.
	End Rem
	Method header:TTLID3v2Header()
		Return TTLID3v2Header(bmx_taglib_id3v2tag_header(tagPtr))
	End Method
	
	Method extendedHeader:TTLID3v2ExtendedHeader()
	End Method
	
	Method footer:TTLID3v2Footer()
	End Method
	
	Method frameListMap:TTLID3v2FrameListMap()
	End Method
	
	Method frameList:TTLID3v2FrameList()
		Return TTLID3v2FrameList._create(bmx_taglib_id3v2tag_framelist(tagPtr))
	End Method
	
	Method addFrame(frame:TTLID3v2Frame)
	End Method
	
	Method removeFrame(frame:TTLID3v2Frame, del:Int = True)
	End Method

End Type

Rem
bbdoc: 
End Rem
Type TTLID3v2FrameList

	Field frameListPtr:Byte Ptr
	
	Function _create:TTLID3v2FrameList(frameListPtr:Byte Ptr) { nomangle }
		If frameListPtr Then
			Local this:TTLID3v2FrameList = New TTLID3v2FrameList
			this.frameListPtr = frameListPtr
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Returns the frame at the specified index.
	End Rem
	Method frame:TTLID3v2Frame(index:Int)
		Return TTLID3v2Frame(bmx_taglib_id3v2framelist_frame(frameListPtr, index))
	End Method
	
	Rem
	bbdoc: Returns True if the list is empty.
	End Rem
	Method isEmpty:Int()
		Return bmx_taglib_id3v2framelist_isempty(frameListPtr)
	End Method
	
	Rem
	bbdoc: Returns the size of the list.
	End Rem
	Method size:Int()
		Return bmx_taglib_id3v2framelist_size(frameListPtr)
	End Method

	Method ObjectEnumerator:TTLID3v2FrameListEnumerator()
		' Reset the iterator
		bmx_taglib_id3v2framelist_reset(frameListPtr)
	
		Local enum:TTLID3v2FrameListEnumerator = New TTLID3v2FrameListEnumerator
		enum.list = Self
		Return enum
	End Method

	Method Delete()
		If frameListPtr Then
			bmx_taglib_id3v2framelist_free(frameListPtr)
			frameListPtr = Null
		End If
	End Method
	
End Type

' internal support for EachIn
Type TTLID3v2FrameListEnumerator
	Field list:TTLID3v2FrameList
	Field nextFrame:TTLID3v2Frame

	Method HasNext:Int()
		If Not nextFrame Then
			nextFrame = TTLID3v2Frame(bmx_taglib_id3v2framelist_nextframe(list.frameListPtr))
		End If
		
		If nextFrame Then
			Return True
		End If
	End Method
	
	Method NextObject:Object()
		Local nextItem:TTLID3v2Frame = nextFrame
		nextFrame = Null
		Return nextItem
	End Method
End Type


Type TTLID3v2FrameListMap

	Field listMapPtr:Byte Ptr

End Type

Type TTLID3V1Tag Extends TTLTag

	Function _create:TTLID3v1Tag(tagPtr:Byte Ptr) { nomangle }
		If tagPtr Then
			Local this:TTLID3v1Tag = New TTLID3v1Tag
			this.tagPtr = tagPtr
			Return this
		End If
	End Function

End Type

Rem
bbdoc: An APE tag implementation.
End Rem
Type TTLAPETag Extends TTLTag

	Function _create:TTLAPETag(tagPtr:Byte Ptr) { nomangle }
		If tagPtr Then
			Local this:TTLAPETag = New TTLAPETag
			this.tagPtr = tagPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Check if the given String is a valid APE tag key.
	End Rem
	Function checkKey:Int(key:String)
		Return bmx_taglib_apetag_checkkey(key)
	End Function

	Rem
	bbdoc: Returns the item list map.
	abtou: This is an ItemListMap of all of the items in the tag.
	This is the most powerfull structure for accessing the items of the tag.
	APE tags are case-insensitive, all keys in this map have been converted to upper case.
	End Rem
	Method itemList:TTLAPEItemListMap()
		Return TTLAPEItemListMap._create(bmx_taglib_apetag_itemlist(tagPtr))
	End Method

End Type

Rem
bbdoc: 
End Rem
Type TTLAPEItemListMap

	Field itemListPtr:Byte Ptr
	
	Function _create:TTLAPEItemListMap(itemListPtr:Byte Ptr) { nomangle }
		If itemListPtr Then
			Local this:TTLAPEItemListMap = New TTLAPEItemListMap
			this.itemListPtr = itemListPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Returns the item for the specified key.
	End Rem
	Method item:TTLAPEItem(key:String)
		Return TTLAPEItem(bmx_taglib_apeitemlistmap_item(itemListPtr, key))
	End Method
	
	Rem
	bbdoc: Returns True if the list is empty.
	End Rem
	Method isEmpty:Int()
		Return bmx_taglib_apeitemlistmap_isempty(itemListPtr)
	End Method
	
	Rem
	bbdoc: Returns the size of the list.
	End Rem
	Method size:Int()
		Return bmx_taglib_apeitemlistmap_size(itemListPtr)
	End Method

	Method ObjectEnumerator:TTLAPEItemListMapEnumerator()
		' Reset the iterator
		bmx_taglib_apeitemlistmap_reset(itemListPtr)
	
		Local enum:TTLAPEItemListMapEnumerator = New TTLAPEItemListMapEnumerator
		enum.list = Self
		Return enum
	End Method

	Method Delete()
		If itemListPtr Then
			bmx_taglib_apeitemlistmap_free(itemListPtr)
			itemListPtr = Null
		End If
	End Method
	
End Type

' internal support for EachIn
Type TTLAPEItemListMapEnumerator
	Field list:TTLAPEItemListMap
	Field nextItem:TTLAPEItem

	Method HasNext:Int()
		If Not nextItem Then
			nextItem = TTLAPEItem(bmx_taglib_apeitemlistmap_nextitem(list.itemListPtr))
		End If
		
		If nextItem Then
			Return True
		End If
	End Method
	
	Method NextObject:Object()
		Local tmpItem:TTLAPEItem = nextItem
		nextItem = Null
		Return tmpItem
	End Method
End Type

Rem
bbdoc: An implementation of APE items.
about: This type provides the features of items in the APEv2 standard.
End Rem
Type TTLAPEItem

	Field itemPtr:Byte Ptr
	
	Function _create:TTLAPEItem(itemPtr:Byte Ptr) { nomangle }
		If itemPtr Then
			Local this:TTLAPEItem = New TTLAPEItem
			this.itemPtr = itemPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Returns the key.
	End Rem
	Method key:String()
		Return bmx_taglib_apeitem_key(itemPtr)
	End Method
	
	Rem
	bbdoc: Returns the size of the full item.
	End Rem
	Method size:Int()
		Return bmx_taglib_apeitem_size(itemPtr)
	End Method

	Rem
	bbdoc: Returns the list of text values.
	End Rem
	Method values:String[]()
		Return bmx_taglib_apeitem_values(itemPtr)
	End Method

	Rem
	bbdoc: Return true if the item is read-only.
	End Rem
	Method isReadOnly:Int()
		Return bmx_taglib_apeitem_isreadonly(itemPtr)
	End Method

	Rem
	bbdoc: Returns if the item has any real content.
	End Rem
	Method isEmpty:Int()
		Return bmx_taglib_apeitem_isempty(itemPtr)
	End Method
	
End Type

Rem
bbdoc: An implementation of ID3v2 headers.
about: It attempts to follow, both semantically and programatically, the structure specified in the ID3v2 standard. The
API is based on the properties of ID3v2 headers specified there. If any of the terms used in this documentation are unclear
please check the specification in the linked section. (Structure, 3.1)
End Rem
Type TTLID3v2Header

	Field headerPtr:Byte Ptr

	Function _create:TTLID3v2Header(headerPtr:Byte Ptr) { nomangle }
		If headerPtr Then
			Local this:TTLID3v2Header = New TTLID3v2Header
			this.headerPtr = headerPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Returns the major version number.
	abotu: Note: This is the 4, not the 2 in ID3v2.4.0. The 2 is implied.
	End Rem
	Method majorVersion:Int()
		Return bmx_taglib_id3v2header_majorversion(headerPtr)
	End Method
	
	Rem
	bbdoc: Returns the revision number.
	about: Note: This is the 0, not the 4 in ID3v2.4.0. The 2 is implied.
	End Rem
	Method revisionNumber:Int()
		Return bmx_taglib_id3v2header_revisionnumber(headerPtr)
	End Method

	Rem
	bbdoc: Returns True if unsynchronisation has been applied to all frames.
	End Rem
	Method unsynchronisation:Int()
		Return bmx_taglib_id3v2header_unsynchronisation(headerPtr)
	End Method

	Rem
	bbdoc: Returns True if an extended header is present in the tag.
	End Rem
	Method extendedHeader:Int()
		Return bmx_taglib_id3v2header_extendedheader(headerPtr)
	End Method

	Rem
	bbdoc: Returns True if the experimental indicator flag is set.
	End Rem
	Method experimentalIndicator:Int()
		Return bmx_taglib_id3v2header_experimentalindicator(headerPtr)
	End Method

	Rem
	bbdoc: Returns True if a footer is present in the tag.
	End Rem
	Method footerPresent:Int()
		Return bmx_taglib_id3v2header_footerpresent(headerPtr)
	End Method

	Rem
	bbdoc: Returns the tag size in bytes.
	about: This is the size of the frame content. The size of the entire tag will be this plus the header size
	(10 bytes) and, if present, the footer size (potentially another 10 bytes).
	<p>
	This is the value as read from the header to which TagLib attempts to provide an API to; it was not a design decision on
	the part of TagLib to not include the mentioned portions of the tag in the size.
	</p>
	End Rem
	Method tagSize:Int()
		Return bmx_taglib_id3v2header_tagsize(headerPtr)
	End Method

	Rem
	bbdoc: Returns the tag size, including the header and, if present, the footer size.
	End Rem
	Method completeTagSize:Int()
		Return bmx_taglib_id3v2header_completetagsize(headerPtr)
	End Method

	Rem
	bbdoc: Sets the tag size to @size.
	End Rem
	Method setTagSize(size:Int)
		bmx_taglib_id3v2header_settagsize(headerPtr, size)
	End Method

	'Method setData(Const ByteVector &data)
	'End Method

End Type

Type TTLID3v2ExtendedHeader

End Type

Type TTLID3v2Footer

End Type

Rem
bbdoc: ID3v2 frame implementation.
about: In ID3v2, a tag is split between a collection of frames (which are in turn split into fields (Structure, 4) (Frames). This type
provides an API for gathering information about and modifying ID3v2 frames. Funtionallity specific to a given frame
type is handed in one of the many subtypes.
End Rem
Type TTLID3v2Frame Extends TTLID3v2Header

	Function _create:TTLID3v2Frame(headerPtr:Byte Ptr) { nomangle }
		If headerPtr Then
			Local this:TTLID3v2Frame = New TTLID3v2Frame
			this.headerPtr = headerPtr
			Return this
		End If
	End Function

	Method size:Int()
		Return bmx_taglib_id3v2frame_size(headerPtr)
	End Method
	
	Method setData(data:TTLByteVector)
	End Method
	
	Method setText(Text:String)
	End Method
	
	Method toString:String()
		Return bmx_taglib_id3v2frame_tostring(headerPtr)
	End Method
	
	Method frameID:TTLByteVector()
		Return TTLByteVector._create(bmx_taglib_id3v2frame_frameid(headerPtr))
	End Method
	
	Method setFrameID(id:TTLByteVector)
	End Method
	
End Type

Rem
bbdoc: An ID3v2 attached picture frame implementation.
about: This is an implementation of ID3v2 attached pictures. Pictures may be included in tags, one per
APIC frame (but there may be multiple APIC frames in a single tag). These pictures are usually in either
JPEG or PNG format.
End Rem
Type TTLID3v2AttachedPictureFrame Extends TTLID3v2Frame

	Function _create:TTLID3v2AttachedPictureFrame(headerPtr:Byte Ptr) { nomangle }
		If headerPtr Then
			Local this:TTLID3v2AttachedPictureFrame = New TTLID3v2AttachedPictureFrame
			this.headerPtr = headerPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: A type not enumerated below.
	End Rem
	Const TYPE_OTHER:Int = $00
	Rem
	bbdoc: 32x32 PNG image that should be used as the file icon
	End Rem
	Const TYPE_FILEICON:Int = $01
	Rem
	bbdoc: File icon of a different size or format.
	End Rem
	Const TYPE_OTHERFILEICON:Int = $02
	Rem
	bbdoc: Front cover image of the album.
	End Rem
	Const TYPE_FRONTCOVER:Int = $03
	Rem
	bbdoc: Back cover image of the album.
	End Rem
	Const TYPE_BACKCOVER:Int = $04
	Rem
	bbdoc: Inside leaflet page of the album.
	End Rem
	Const TYPE_LEAFLETPAGE:Int = $05
	Rem
	bbdoc: Image from the album itself.
	End Rem
	Const TYPE_MEDIA:Int = $06
	Rem
	bbdoc: Picture of the lead artist or soloist.
	End Rem
	Const TYPE_LEADARTIST:Int = $07
	Rem
	bbdoc: Picture of the artist or performer.
	End Rem
	Const TYPE_ARTIST:Int = $08
	Rem
	bbdoc: Picture of the conductor.
	End Rem
	Const TYPE_CONDUCTOR:Int = $09
	Rem
	bbdoc: Picture of the band or orchestra.
	End Rem
	Const TYPE_BAND:Int = $0A
	Rem
	bbdoc: Picture of the composer.
	End Rem
	Const TYPE_COMPOSER:Int = $0B
	Rem
	bbdoc: Picture of the lyricist or text writer.
	End Rem
	Const TYPE_LYRICIST:Int = $0C
	Rem
	bbdoc: Picture of the recording location or studio.
	End Rem
	Const TYPE_RECORDINGLOCATION:Int = $0D
	Rem
	bbdoc: Picture of the artists during recording.
	End Rem
	Const TYPE_DURINGRECORDING:Int = $0E
	Rem
	bbdoc: Picture of the artists during performance.
	End Rem
	Const TYPE_DURINGPERFORMANCE:Int = $0F
	Rem
	bbdoc: Picture from a movie or video related to the track.
	End Rem
	Const TYPE_MOVIESCREENCAPTURE:Int = $10
	Rem
	bbdoc: Picture of a large, coloured fish.
	End Rem
	Const TYPE_COLOUREDFISH:Int = $11
	Rem
	bbdoc: Illustration related to the track.
	End Rem
	Const TYPE_ILLUSTRATION:Int = $12
	Rem
	bbdoc: Logo of the band or performer.
	End Rem
	Const TYPE_BANDLOGO:Int = $13
	Rem
	bbdoc: Logo of the publisher (record company).
	End Rem
	Const TYPE_PUBLISHERLOGO:Int = $14

	Rem
	bbdoc: Returns the text encoding used for the description.
	End Rem
	Method textEncoding:Int()
		Return bmx_taglib_id3v2attachedpictureframe_textencoding(headerPtr)
	End Method
	
	Method setTextEncoding(encoding:Int)
	End Method
	
	Rem
	bbdoc: Returns the mime type of the image.
	about: This should in most cases be "image/png" or "image/jpeg".
	End Rem
	Method mimeType:String()
		Return bmx_taglib_id3v2attachedpictureframe_mimetype(headerPtr)
	End Method
	
	Method setMimeType(m:String)
	End Method
	
	Rem
	bbdoc: Returns the type of the image.
	End Rem
	Method imageType:Int()
		Return bmx_taglib_id3v2attachedpictureframe_imagetype(headerPtr)
	End Method
	
	Method setImageType(t:Int)
	End Method
	
	Rem
	bbdoc: Returns a text description of the image.
	End Rem
	Method description:String()
		Return bmx_taglib_id3v2attachedpictureframe_description(headerPtr)
	End Method
	
	Method setDescription(desc:String)
	End Method
	
	Rem
	bbdoc: Returns the image data as a TTLByteVector.
	End Rem
	Method picture:TTLByteVector()
		Return TTLByteVector._create(bmx_taglib_id3v2attachedpictureframe_picture(headerPtr))
	End Method
	
	Method setPicture(data:TTLByteVector)
	End Method
	
End Type

Rem
bbdoc: An implementation of ID3v2 comments. 
about: An ID3v2 comment consists of a language encoding, a description and a single text field. 
End Rem
Type TTLID3v2CommentsFrame Extends TTLID3v2Frame

	Function _create:TTLID3v2CommentsFrame(headerPtr:Byte Ptr) { nomangle }
		If headerPtr Then
			Local this:TTLID3v2CommentsFrame = New TTLID3v2CommentsFrame
			this.headerPtr = headerPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Returns the text of this comment.
	End Rem
	Method toString:String()
		Return bmx_taglib_id3v2commentsframe_tostring(headerPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method language:TTLByteVector()
		' TODO
	End Method
	
	Rem
	bbdoc: Returns the description of this comment.
	about: Note: Most taggers simply ignore this value.
	End Rem
	Method description:String()
		Return bmx_taglib_id3v2commentsframe_description(headerPtr)
	End Method
	
	Rem
	bbdoc: Returns the text of this comment.
	End Rem
	Method Text:String()
		Return bmx_taglib_id3v2commentsframe_text(headerPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method setLanguage(languageCode:TTLByteVector)
		' TODO
	End Method
	
	Rem
	bbdoc: Sets the description of the comment. 
	End Rem
	Method setDescription(description:String)
		bmx_taglib_id3v2commentsframe_setdescription(headerPtr, description)
	End Method
	
	Rem
	bbdoc: Sets the text portion of the comment.
	End Rem
	Method setText(Text:String)
		bmx_taglib_id3v2commentsframe_settext(headerPtr, Text)
	End Method
	
	Rem
	bbdoc: Returns the text encoding that will be used in rendering this frame.
	about: This defaults to the type that was either specified in the constructor or read from the frame when parsed.
	End Rem
	Method textEncoding:Int()
		Return bmx_taglib_id3v2commentsframe_textencoding(headerPtr)
	End Method
	
	Rem
	bbdoc: Sets the text encoding to be used when rendering this frame to encoding.
	End Rem
	Method setTextEncoding(encoding:Int)
		bmx_taglib_id3v2commentsframe_settextencoding(headerPtr, encoding)
	End Method

End Type

Type TTLID3v2GeneralEncapsulatedObjectFrame Extends TTLID3v2Frame

	Function _create:TTLID3v2GeneralEncapsulatedObjectFrame(headerPtr:Byte Ptr) { nomangle }
		If headerPtr Then
			Local this:TTLID3v2GeneralEncapsulatedObjectFrame = New TTLID3v2GeneralEncapsulatedObjectFrame
			this.headerPtr = headerPtr
			Return this
		End If
	End Function

End Type

Type TTLID3v2RelativeVolumeFrame Extends TTLID3v2Frame

	Function _create:TTLID3v2RelativeVolumeFrame(headerPtr:Byte Ptr) { nomangle }
		If headerPtr Then
			Local this:TTLID3v2RelativeVolumeFrame = New TTLID3v2RelativeVolumeFrame
			this.headerPtr = headerPtr
			Return this
		End If
	End Function

End Type

Rem
bbdoc: An ID3v2 text identification frame implementation.
about: This is an implementation of the most common type of ID3v2 frame -- text identification frames.
There are a number of variations on this. Those enumerated in the ID3v2.4 standard are:
<ul>
<li><b>TALB</b> : Album/Movie/Show title </li>
<li><b>TBPM</b> : BPM (beats per minute) </li>
<li><b>TCOM</b> : Composer </li>
<li><b>TCON</b> : Content type </li>
<li><b>TCOP</b> : Copyright message </li>
<li><b>TDEN</b> : Encoding time </li>
<li><b>TDLY</b> : Playlist delay </li>
<li><b>TDOR</b> : Original release time </li>
<li><b>TDRC</b> : Recording time </li>
<li><b>TDRL</b> : Release time </li>
<li><b>TDTG</b> : Tagging time </li>
<li><b>TENC</b> : Encoded by </li>
<li><b>TEXT</b> : Lyricist/Text writer </li>
<li><b>TFLT</b> : File type </li>
<li><b>TIPL</b> : Involved people list </li>
<li><b>TIT1</b> : Content group description </li>
<li><b>TIT2</b> : Title/songname/content description </li>
<li><b>TIT3</b> : Subtitle/Description refinement </li>
<li><b>TKEY</b> : Initial key </li>
<li><b>TLAN</b> : Language(s) </li>
<li><b>TLEN</b> : Length </li>
<li><b>TMCL</b> : Musician credits list </li>
<li><b>TMED</b> : Media type </li>
<li><b>TMOO</b> : Mood </li>
<li><b>TOAL</b> : Original album/movie/show title </li>
<li><b>TOFN</b> : Original filename </li>
<li><b>TOLY</b> : Original lyricist(s)/text writer(s) </li>
<li><b>TOPE</b> : Original artist(s)/performer(s) </li>
<li><b>TOWN</b> : File owner/licensee </li>
<li><b>TPE1</b> : Lead performer(s)/Soloist(s) </li>
<li><b>TPE2</b> : Band/orchestra/accompaniment </li>
<li><b>TPE3</b> : Conductor/performer refinement </li>
<li><b>TPE4</b> : Interpreted, remixed, or otherwise modified by </li>
<li><b>TPOS</b> : Part of a set </li>
<li><b>TPRO</b> : Produced notice </li>
<li><b>TPUB</b> : Publisher </li>
<li><b>TRCK</b> : Track number/Position in set </li>
<li><b>TRSN</b> : Internet radio station name </li>
<li><b>TRSO</b> : Internet radio station owner </li>
<li><b>TSOA</b> : Album sort order </li>
<li><b>TSOP</b> : Performer sort order </li>
<li><b>TSOT</b> : Title sort order </li>
<li><b>TSRC</b> : ISRC (international standard recording code) </li>
<li><b>TSSE</b> : Software/Hardware and settings used for encoding </li>
<li><b>TSST</b> : Set subtitle </li>
</ul>
TTLID3v2Header.frameID() can be used to determine the frame type.
<p>
Note: If non-Latin1 compatible strings are used with this class, even if the text encoding
is set to Latin1, the frame will be written using UTF8 (with the encoding flag appropriately set in the output). 
</p>
End Rem
Type TTLID3v2TextIdentificationFrame Extends TTLID3v2Frame

	Function _create:TTLID3v2TextIdentificationFrame(headerPtr:Byte Ptr) { nomangle }
		If headerPtr Then
			Local this:TTLID3v2TextIdentificationFrame = New TTLID3v2TextIdentificationFrame
			this.headerPtr = headerPtr
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Set the text of frame in the sanest way possible. 
	about: Note: If the frame type supports multiple text encodings, this will not change the text encoding
	of the frame; the string will be converted to that frame's encoding. Please use the specific APIs of the
	frame types to set the encoding if that is desired.
	End Rem
	Method setText(Text:String)
		bmx_taglib_id3v2textidentificationframe_settext(headerPtr, Text)
	End Method
	
	Rem
	bbdoc: Sets the list of string fields.
	about: Note: This will not change the text encoding of the frame even if the strings passed in are not of
	the same encoding. Please use setEncoding(s.type()) if you wish to change the encoding of the frame.
	End Rem
	Method setTextList(Text:String[])
		bmx_taglib_id3v2textidentificationframe_settextlist(headerPtr, Text)
	End Method
	
	Rem
	bbdoc: This returns the textual representation of the data in the frame.
	End Rem
	Method toString:String()
		Return bmx_taglib_id3v2textidentificationframe_tostring(headerPtr)
	End Method
	
	Rem
	bbdoc: Returns the text encoding that will be used in rendering this frame.
	about: This defaults to the type that was either specified in the constructor or read from the frame when parsed.
	<p>
	One of #STRINGTYPE_LATIN1, #STRINGTYPE_UTF16, #STRINGTYPE_UTF16BE, #STRINGTYPE_UTF8 or #STRINGTYPE_UTF16LE.
	</p>
	End Rem
	Method textEncoding:Int()
		Return bmx_taglib_id3v2textidentificationframe_textencoding(headerPtr)
	End Method
	
	Rem
	bbdoc: Sets the text encoding to be used when rendering this frame to encoding.
	about: Can be one of #STRINGTYPE_LATIN1, #STRINGTYPE_UTF16, #STRINGTYPE_UTF16BE, #STRINGTYPE_UTF8
	or #STRINGTYPE_UTF16LE.
	End Rem
	Method setTextEncoding(encoding:Int)
		bmx_taglib_id3v2textidentificationframe_settextencoding(headerPtr, encoding)
	End Method
	
	Rem
	bbdoc: Returns a list of the strings in this frame. 
	End Rem
	Method fieldList:String[]()
		Return bmx_taglib_id3v2textidentificationframe_fieldlist(headerPtr)
	End Method
	
End Type

Type TTLID3v2UserTextIdentificationFrame Extends TTLID3v2TextIdentificationFrame

	Function _create:TTLID3v2UserTextIdentificationFrame(headerPtr:Byte Ptr) { nomangle }
		If headerPtr Then
			Local this:TTLID3v2UserTextIdentificationFrame = New TTLID3v2UserTextIdentificationFrame
			this.headerPtr = headerPtr
			Return this
		End If
	End Function

End Type

Type TTLID3v2UniqueFileIdentifierFrame Extends TTLID3v2Frame

	Function _create:TTLID3v2UniqueFileIdentifierFrame(headerPtr:Byte Ptr) { nomangle }
		If headerPtr Then
			Local this:TTLID3v2UniqueFileIdentifierFrame = New TTLID3v2UniqueFileIdentifierFrame
			this.headerPtr = headerPtr
			Return this
		End If
	End Function

End Type

Type TTLID3v2UnknownFrame Extends TTLID3v2Frame

	Function _create:TTLID3v2UnknownFrame(headerPtr:Byte Ptr) { nomangle }
		If headerPtr Then
			Local this:TTLID3v2UnknownFrame = New TTLID3v2UnknownFrame
			this.headerPtr = headerPtr
			Return this
		End If
	End Function

End Type

Type TTLID3v2UnsynchronizedLyricsFrame Extends TTLID3v2Frame

	Function _create:TTLID3v2UnsynchronizedLyricsFrame(headerPtr:Byte Ptr) { nomangle }
		If headerPtr Then
			Local this:TTLID3v2UnsynchronizedLyricsFrame = New TTLID3v2UnsynchronizedLyricsFrame
			this.headerPtr = headerPtr
			Return this
		End If
	End Function

End Type

Rem
bbdoc: ID3v2 URL frame.
about: An implementation of ID3v2 URL link frames. 
End Rem
Type TTLID3v2UrlLinkFrame Extends TTLID3v2Frame

	Function _create:TTLID3v2UrlLinkFrame(headerPtr:Byte Ptr) { nomangle }
		If headerPtr Then
			Local this:TTLID3v2UrlLinkFrame = New TTLID3v2UrlLinkFrame
			this.headerPtr = headerPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Returns the URL. 
	End Rem
	Method url:String()
		Return bmx_taglib_id3v2urllinkframe_url(headerPtr)
	End Method
	
	Rem
	bbdoc: Sets the URL to @text.
	End Rem
	Method setUrl(Text:String)
		bmx_taglib_id3v2urllinkframe_seturl(headerPtr, Text)
	End Method
	
	Rem
	bbdoc: Sets the text of frame in the sanest way possible. 
	End Rem
	Method setText(Text:String)
		bmx_taglib_id3v2urllinkframe_settext(headerPtr, Text)
	End Method
	
	Rem
	bbdoc: Returns the textual representation of the data in the frame. 
	End Rem
	Method toString:String()
		Return bmx_taglib_id3v2urllinkframe_tostring(headerPtr)
	End Method
	
End Type

Type TTLID3v2UserUrlLinkFrame Extends TTLID3v2UrlLinkFrame

	Function _create:TTLID3v2UserUrlLinkFrame(headerPtr:Byte Ptr) { nomangle }
		If headerPtr Then
			Local this:TTLID3v2UserUrlLinkFrame = New TTLID3v2UserUrlLinkFrame
			this.headerPtr = headerPtr
			Return this
		End If
	End Function

End Type

Rem
bbdoc: A byte vector.
about: This type provides a byte vector with some methods that are useful for tagging purposes.
Many of the search functions are tailored to what is useful for finding tag related paterns in a data array.
End Rem
Type TTLByteVector

	Field bvPtr:Byte Ptr
	
	Function _create:TTLByteVector(bvPtr:Byte Ptr) { nomangle }
		If bvPtr Then
			Local this:TTLByteVector = New TTLByteVector
			this.bvPtr = bvPtr
			Return this
		End If
	End Function
	
	Function CreateByteVector:TTLByteVector(data:Byte Ptr, length:Int)
		Return New TTLByteVector.Create(data, length)
	End Function
	
	Method Create:TTLByteVector(data:Byte Ptr, length:Int)
		'bvPtr = ...
		Return Self
	End Method

	Method setData(data:Byte Ptr, length:Int)
	End Method
	
	Rem
	bbdoc: Returns a pointer to the internal data structure.
	about: <b>Warning :</b> Care should be taken when modifying this data structure as it is easy to corrupt
	the TTLByteVector when doing so. Specifically, while the data may be changed, its length may not be.
	End Rem
	Method data:Byte Ptr()
		Return bmx_taglib_bytevector_data(bvPtr)
	End Method
	
	Rem
	bbdoc: Clears the data.
	End Rem
	Method clear()
		bmx_taglib_bytevector_clear(bvPtr)
	End Method
	
	Rem
	bbdoc: Returns the size of the array.
	End Rem
	Method size:Int()
		Return bmx_taglib_bytevector_size(bvPtr)
	End Method

	Rem
	bbdoc: Returns true if the byte vector is empty.
	End Rem
	Method isEmpty:Int()
		Return bmx_taglib_bytevector_isempty(bvPtr)
	End Method
	
	Rem
	bbdoc: Returns a string representation of the byte vector.
	about: This is only useful for text-based data.
	End Rem
	Method toString:String()
		Return bmx_taglib_bytevector_tostring(bvPtr)
	End Method
	
	Rem
	bbdoc: Returns a TBank representation of the byte vector.
	about: The data in the bank is only valid for the life of the parent TTLByteVector object.
	End Rem
	Method bank:TBank()
		If size() > 0 Then
			Return TBank.CreateStatic(data(), size())
		Else
			Return Null
		End If
	End Method
	
	Method Delete()
		If bvPtr Then
			bmx_taglib_bytevector_free(bvPtr)
			bvPtr = Null
		End If
	End Method

End Type



