﻿<%

' File: json.asp
' 
' AXE(ASP Xtreme Evolution) json file media.
' 
' License:
' 
' This file is part of ASP Xtreme Evolution.
' Copyright (C) 2007-2012 Fabio Zendhi Nagao
' 
' ASP Xtreme Evolution is free software: you can redistribute it and/or modify
' it under the terms of the GNU Lesser General Public License as published by
' the Free Software Foundation, either version 3 of the License, or
' (at your option) any later version.
' 
' ASP Xtreme Evolution is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' GNU Lesser General Public License for more details.
' 
' You should have received a copy of the GNU Lesser General Public License
' along with ASP Xtreme Evolution. If not, see <http://www.gnu.org/licenses/>.



' Class: Translator_Media_Json
' 
' This class enables Translator to use data stored in json files.
' 
' About:
' 
'     - Written by Fabio Zendhi Nagao <http://zend.lojcomm.com.br> @ Dec 2010
' 
class Translator_Media_Json' implements Translator_Interface
    
    ' --[ Interface ]-----------------------------------------------------------
    public Interface
    
    ' --[ Media definition ]--------------------------------------------------
    
    ' Property: classType
    ' 
    ' Class type.
    ' 
    ' Contains:
    ' 
    '   (string) - type
    ' 
    public classType

    ' Property: classVersion
    ' 
    ' Class version.
    ' 
    ' Contains:
    ' 
    '   (string) - version
    ' 
    public classVersion
    
    ' Property: path
    ' 
    ' File System physical path
    ' 
    ' Contains:
    ' 
    '     (string) - file system physical path
    ' 
    public path
    
    ' Property: encoding
    ' 
    ' Text encoding
    ' 
    ' Contains:
    ' 
    '     (Stream.charset) - text encoding. Defaults to UTF-8
    ' 
    public encoding
    
    private sub Class_initialize()
        classType    = typename(Me)
        classVersion = "1.0.0.0"
        
        set Interface = new Translator_Interface
        set Interface.Implementation = Me
        if(not Interface.check) then
            Err.raise 17, "Evolved AXE runtime error", strsubstitute( _
                "Can't perform requested operation. '{0}' is a bad interface implementation of '{1}'", _
                array(classType, typename(Interface)) _
            )
        end if
        
        encoding = "UTF-8"
    end sub
    
    private sub Class_terminate()
        set Interface.Implementation = nothing
        set Interface = nothing
    end sub
    
    ' Function: load
    ' 
    ' Returns the serialized Translator from the json file.
    ' 
    ' Returns:
    ' 
    '     (string) - Translator serialized content
    ' 
    public function load()
        if(varType(path) = vbEmpty) then
            Err.raise 5, "Evolved AXE runtime error", strsubstitute( _
                "Invalid procedure call or argument. '{0}' property 'path' isn't defined", _
                array(classType) _
            )
        end if
        
        dim Fso : set Fso = Server.createObject("Scripting.FileSystemObject")
        if( Fso.fileExists(path) ) then
            dim Stream : set Stream = Server.createObject("ADODB.Stream")
            with Stream
                .type = adTypeText
                .mode = adModeReadWrite
                .charset = "UTF-8"
                .open()
                
                .loadFromFile(path)
                .position = 0
                load = JSON.minify( .readText() )
                
                .close()
            end with
            set Stream = nothing
        else
            load = "{}"
        end if
        set Fso = nothing
    end function
    
end class

%>
