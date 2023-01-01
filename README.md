![](https://github.com/senselogic/REMIX/blob/master/LOGO/remix.png)

# Remix

Update command runner.

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

If any input file path is newer than any output file path, the command is executed with the provided arguments.

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

```bash
remix @from:convert_images.sh ../TOOL/IMAGE_MAGICK/convert input.jpg output.jpg
remix @from:convert_images.sh ../TOOL/IMAGE_MAGICK/convert "input file.jpg" "output file.jpg"
remix @from:convert_images.sh @in:../TOOL/IMAGE_MAGICK/convert @in:input.jpg @out:output.jpg
remix @from:convert_images.sh @in:../TOOL/IMAGE_MAGICK/convert "@in:input file.jpg" "@out:output file.jpg"
```

Runs the command if the script file or executable file or input file is newer than the output file.

## Version

0.1

## Author

Eric Pelzer (ecstatic.coder@gmail.com).

## License

This project is licensed under the GNU General Public License version 3.

See the [LICENSE.md](LICENSE.md) file for details.
