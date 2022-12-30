/*
    This file is part of the Forge distribution.

    https://github.com/senselogic/FORGE

    Copyright (C) 2022 Eric Pelzer (ecstatic.coder@gmail.com)

    Forge is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3.

    Forge is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Forge.  If not, see <http://www.gnu.org/licenses/>.
*/

// -- IMPORTS

import core.stdc.stdlib : exit;
import std.datetime : SysTime, UTC;
import std.file : exists, getTimes;
import std.stdio : writeln;
import std.string : endsWith, indexOf, join, replace, startsWith;
import std.process : execute, executeShell;

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
            else if ( character < 'a'
                      || character > 'z' )
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
    string[] input_file_path_array,
    string[] output_file_path_array
    )
{
    foreach ( output_file_path; output_file_path_array )
    {
        if ( !output_file_path.exists() )
        {
            return false;
        }
    }

    foreach ( input_file_path; input_file_path_array )
    {
        foreach ( output_file_path; output_file_path_array )
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

string GetShellCommand(
    string[] command_argument_array
    )
{
    foreach ( ref command_argument; command_argument_array )
    {
        if ( command_argument.indexOf( ' ' ) >= 0
             && !command_argument.startsWith( '"' )
             && !command_argument.endsWith( '"' ) )
        {
            command_argument = "\"" ~ command_argument ~ "\"";
        }
    }

    return command_argument_array.join( ' ' );
}

// ~~

void ExecuteCommand(
    string[] command_argument_array,
    string[] input_file_path_array,
    string[] output_file_path_array
    )
{
    string
        executable_file_path,
        shell_command;

    if ( command_argument_array.length > 0 )
    {
        shell_command = GetShellCommand( command_argument_array );

        executable_file_path = GetExecutableFilePath( GetLogicalPath( command_argument_array[ 0 ] ) );

        if ( executable_file_path != "" )
        {
            if ( HasNewInputFile( input_file_path_array, output_file_path_array ) )
            {
                writeln( "Executing command : ", shell_command );

                execute( command_argument_array );
            }
            else
            {
                writeln( "Skipping command : ", shell_command );
            }
        }
        else
        {
            if ( HasNewInputFile( input_file_path_array, output_file_path_array ) )
            {
                writeln( "Executing shell command : ", shell_command );

                executeShell( shell_command );
            }
            else
            {
                writeln( "Skipping shell command : ", shell_command );
            }
        }
    }
}

// ~~

void ProcessCommand(
    string[] command_argument_array
    )
{
    string
        executable_file_path;
    string[]
        argument_array,
        input_file_path_array,
        output_file_path_array;

    foreach ( command_argument; command_argument_array )
    {
        if ( command_argument.startsWith( "@from:" ) )
        {
            input_file_path_array ~= GetLogicalPath( command_argument[ 6 .. $ ] );
        }
        else if ( command_argument.startsWith( "@to:" ) )
        {
            output_file_path_array ~= GetLogicalPath( command_argument[ 4 .. $ ] );
        }
        else
        {
            argument_array ~= command_argument;
        }
    }

    foreach ( argument_index, ref argument; argument_array )
    {
        if ( argument.startsWith( "@in:" ) )
        {
            argument = argument[ 4 .. $ ];

            input_file_path_array ~= GetLogicalPath( argument );
        }
        else if ( argument.startsWith( "@out:" ) )
        {
            argument = argument[ 5 .. $ ];

            output_file_path_array ~= GetLogicalPath( argument );
        }
        else if ( argument.startsWith( "@:" ) )
        {
            argument = argument[ 2 .. $ ];
        }
        else if ( argument_index == 0 )
        {
            executable_file_path = GetExecutableFilePath( GetLogicalPath( argument ) );

            if ( executable_file_path != "" )
            {
                input_file_path_array ~= executable_file_path;
            }
        }
        else
        {
            if ( HasFileExtension( GetLogicalPath( argument ) ) )
            {
                if ( argument_index == argument_array.length - 1 )
                {
                    output_file_path_array ~= GetLogicalPath( argument );
                }
                else
                {
                    input_file_path_array ~= GetLogicalPath( argument );
                }
            }
        }
    }

    ExecuteCommand( argument_array, input_file_path_array, output_file_path_array );
}

// ~~

void main(
    string[] argument_array
    )
{
    ProcessCommand( argument_array[ 1 .. $ ] );
}
