![](https://github.com/senselogic/REMIX/blob/master/LOGO/remix.png)

# Remix

Update command manager.

## Description

Remix parses the provided command to find input and output files, and runs it only if an output file is missing or if an input file path is newer than an output file.

## Installation

Install the [DMD 2 compiler](https://dlang.org/download.html) (using the MinGW setup option on Windows).

Build the executable with the following command line :

```bash
dmd -m64 remix.d
```

## Command line

```
remix [<option> ...] <command> [<argument> ...]
```

### Options

```
@clean : remove the output files
@force : run the command unconditionally
```

### Command

The command is treated as an input file path.

### Arguments

An argument with a file path extension is treated as an input file path.

The last argument with a file path extension is treated as an output file path.

An argument with a role prefix is treated as follows :

```
@:<non file path>
@in:<input file path>
@out:<output file path>
@from:<source file path>
@to:<target file path>
```

### Examples

```bash
remix ../TOOL/IMAGE_MAGICK/convert input.jpg output.jpg
remix ../TOOL/IMAGE_MAGICK/convert "input file.jpg" "output file.jpg"
remix @in:../TOOL/IMAGE_MAGICK/convert @in:input.jpg @in:output.jpg
remix @in:../TOOL/IMAGE_MAGICK/convert "@in:input file.jpg" "@in:output file.jpg"
```

Runs the command if the executable file or the input file is newer than the output file.

```bash
remix @force ../TOOL/IMAGE_MAGICK/convert input.jpg output.jpg
remix @force ../TOOL/IMAGE_MAGICK/convert "input file.jpg" "output file.jpg"
remix @force @in:../TOOL/IMAGE_MAGICK/convert @in:input.jpg @in:output.jpg
remix @force @in:../TOOL/IMAGE_MAGICK/convert "@in:input file.jpg" "@in:output file.jpg"
```

Runs the command unconditionally.

## Version

0.2

## Author

Eric Pelzer (ecstatic.coder@gmail.com).

## License

This project is licensed under the GNU General Public License version 3.

See the [LICENSE.md](LICENSE.md) file for details.
