![](https://github.com/senselogic/REMIX/blob/master/LOGO/remix.png)

# Remix

Update command manager.

## Description

*   Parses the command to find its executable, input and output files;
*   Runs the command only if an output file is missing or if the command executable or some input files are newer than the output files.

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

### Arguments

An argument is treated as an input file path if it ends with a file extension.

The last argument is treated as an output file path if it ends with a file extension.

An argument starting with a role prefix is treated as follows :

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

Runs the command if the executable or the input file is newer than the output file.

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
