/*
    This file is part of the Remix distribution.

    https://github.com/senselogic/REMIX

    Copyright (C) 2022 Eric Pelzer (ecstatic.coder@gmail.com)

    Remix is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3.

    Remix is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Remix.  If not, see <http://www.gnu.org/licenses/>.
*/

// -- IMPORTS

import core.stdc.stdlib : exit;
import std.datetime : SysTime, UTC;
import std.file : exists, getTimes, remove;
import std.stdio : writeln;
import std.string : endsWith, indexOf, join, replace, startsWith;
import std.process : spawnShell, wait;

// -- VARIABLES

bool
    CleanOptionIsEnabled,
    ForceOptionIsEnabled;
string[]
    InputFilePathArray,
    OutputFilePathArray;

// -- FUNCTIONS

void PrintError(
    string message
    )
{
    writeln( "*** ERROR : ", message );
}

// ~~

void Abort(
    string message
    )
{
    PrintError( message );

    exit( -1 );
}

// ~~

void Abort(
    string message,
    Exception exception
    )
{
    PrintError( message );
    PrintError( exception.msg );

    exit( -1 );
}

// ~~

string GetLogicalPath(
    string path
    )
{
    return path.replace( '\\', '/' );
}

// ~~

bool HasFileExtension(
    string file_path
    )
{
    char
        character;
    long
        character_index;

    if ( file_path == "" )
    {
        return false;
    }
    else
    {
        for ( character_index = file_path.length - 1;
              character_index >= 0;
              --character_index )
        {
            character = file_path[ character_index ];

            if ( character == '.' )
            {
                return character_index < file_path.length - 1;
            }
            else if ( character == '/'
                      || character == '\\' )
            {
                return false;
            }
            else if ( ! ( ( character >= 'a'
                            && character <= 'z' )
                          || ( character >= 'A'
                               && character <= 'Z' )
                          || ( character >= '0'
                               && character <= '9' ) ) )
            {
                return false;
            }
        }
    }

    return false;
}

// ~~

string GetExecutableFilePath(
    string file_path
    )
{
    string
        executable_file_path;

    file_path = GetLogicalPath( file_path );

    if ( file_path.exists() )
    {
        return file_path;
    }
    else
    {
        if ( !HasFileExtension( file_path ) )
        {
            foreach ( file_extension; [ ".com", ".exe", ".bat" ] )
            {
                executable_file_path = file_path ~ file_extension;

                if ( executable_file_path.exists() )
                {
                    return executable_file_path;
                }
            }
        }
    }

    return "";
}

// ~~

void AddInputFilePath(
    string input_file_path
    )
{
    InputFilePathArray ~= GetLogicalPath( input_file_path );
}

// ~~

void AddOutputFilePath(
    string output_file_path
    )
{
    OutputFilePathArray ~= GetLogicalPath( output_file_path );
}

// ~~

bool IsNewInputFile(
    string input_file_path,
    string output_file_path
    )
{
    SysTime
        input_access_time,
        input_modification_time,
        output_access_time,
        output_modification_time;

    input_file_path.getTimes( input_access_time, input_modification_time );
    output_file_path.getTimes( output_access_time, output_modification_time );

    return input_modification_time > output_modification_time;
}

// ~~

bool HasNewInputFile(
    )
{
    foreach ( output_file_path; OutputFilePathArray )
    {
        if ( !output_file_path.exists() )
        {
            return true;
        }
    }

    foreach ( input_file_path; InputFilePathArray )
    {
        foreach ( output_file_path; OutputFilePathArray )
        {
            if ( input_file_path.exists()
                 && IsNewInputFile( input_file_path, output_file_path ) )
            {
                return true;
            }
        }
    }

    return false;
}

// ~~

string GetCommand(
    string[] command_argument_array
    )
{
    foreach ( ref command_argument; command_argument_array )
    {
        if ( command_argument == ""
             || command_argument.indexOf( ' ' ) >= 0
             || command_argument.indexOf( '"' ) >= 0 )
        {
            command_argument = "\"" ~ command_argument ~ "\"";
        }
    }

    return command_argument_array.join( ' ' );
}

// ~~

void RemoveFile(
    string file_path
    )
{
    try
    {
        writeln( "Removing file : ", file_path );

        file_path.remove();
    }
    catch ( Exception exception )
    {
        Abort( "Can't remove file : " ~ file_path, exception );
    }
}

// ~~

void RemoveOuputFiles(
    )
{
    foreach ( output_file_path; OutputFilePathArray )
    {
        RemoveFile( output_file_path );
    }
}

// ~~

void ExecuteCommand(
    string command
    )
{
    try
    {
        writeln( "Executing command : ", command );

        wait( spawnShell( command ) );
    }
    catch ( Exception exception )
    {
        Abort( "Can't execute command : " ~ command, exception );
    }
}

// ~~

void ExecuteCommand(
    string[] command_argument_array
    )
{
    string
        command,
        executable_file_path;

    if ( command_argument_array.length > 0 )
    {
        command = GetCommand( command_argument_array );

        if ( CleanOptionIsEnabled )
        {
            RemoveOuputFiles();
        }

        if ( ForceOptionIsEnabled
             || HasNewInputFile() )
        {
            ExecuteCommand( command );
        }
        else
        {
            writeln( "Skipping command : ", command );
        }
    }
}

// ~~

void main(
    string[] argument_array
    )
{
    string
        executable_file_path;
    string[]
        command_argument_array;

    CleanOptionIsEnabled = false;
    ForceOptionIsEnabled = false;
    InputFilePathArray = null;
    OutputFilePathArray = null;

    argument_array = argument_array[ 1 .. $ ];

    foreach ( argument; argument_array )
    {
        if ( argument.startsWith( "@clean" ) )
        {
            CleanOptionIsEnabled = true;
        }
        else if ( argument.startsWith( "@force" ) )
        {
            ForceOptionIsEnabled = true;
        }
        else if ( argument.startsWith( "@from:" ) )
        {
            AddInputFilePath( argument[ 6 .. $ ] );
        }
        else if ( argument.startsWith( "@to:" ) )
        {
            AddOutputFilePath( argument[ 4 .. $ ] );
        }
        else
        {
            command_argument_array ~= argument;
        }
    }

    foreach ( command_argument_index, ref command_argument; command_argument_array )
    {
        if ( command_argument.startsWith( "@in:" ) )
        {
            command_argument = command_argument[ 4 .. $ ];

            AddInputFilePath( command_argument );
        }
        else if ( command_argument.startsWith( "@out:" ) )
        {
            command_argument = command_argument[ 5 .. $ ];

            AddOutputFilePath( command_argument );
        }
        else if ( command_argument.startsWith( "@:" ) )
        {
            command_argument = command_argument[ 2 .. $ ];
        }
        else if ( command_argument_index == 0 )
        {
            executable_file_path = GetExecutableFilePath( command_argument );

            if ( executable_file_path != "" )
            {
                AddInputFilePath( executable_file_path );
            }
        }
        else
        {
            if ( HasFileExtension( command_argument ) )
            {
                if ( command_argument_index == command_argument_array.length - 1 )
                {
                    AddOutputFilePath( command_argument );
                }
                else
                {
                    AddInputFilePath( command_argument );
                }
            }
        }
    }

    ExecuteCommand( command_argument_array );
}
