![](https://github.com/senselogic/FORGE/blob/master/LOGO/forge.png)

# Forge

Conditional command processor.

## Installation

Install the [DMD 2 compiler](https://dlang.org/download.html) (using the MinGW setup option on Windows).

Build the executable with the following command line :

```bash
dmd -m64 forge.d
```

## Command line

```
forge <argument> ...
```

### Roles

The first argument is treated as an input file path.

An argument with a file path extension is treated as an input file path.

The last argument with a file path extension is treated as an output file path.

An argument with a role prefix is treated as follows :

```
@: non file path
@in: input file path
@out: output file path
@from: source file path
@to: target file path
```

If any input file path is newer than any output file path, the command is executed with the provided arguments.

### Examples

```bash
forge ../TOOL/IMAGE_MAGICK/convert input.jpg output.jpg
forge ../TOOL/IMAGE_MAGICK/convert "input file.jpg" "output file.jpg"
forge @in:../TOOL/IMAGE_MAGICK/convert @in:input.jpg @in:output.jpg
forge @in:../TOOL/IMAGE_MAGICK/convert "@in:input file.jpg" "@in:output file.jpg"
```

Runs the command if the executable file or the input file is newer than the output file.

```bash
forge @from:convert_images.sh ../TOOL/IMAGE_MAGICK/convert input.jpg output.jpg
forge @from:convert_images.sh ../TOOL/IMAGE_MAGICK/convert "input file.jpg" "output file.jpg"
forge @from:convert_images.sh @in:../TOOL/IMAGE_MAGICK/convert @in:input.jpg @out:output.jpg
forge @from:convert_images.sh @in:../TOOL/IMAGE_MAGICK/convert "@in:input file.jpg" "@out:output file.jpg"
```

Runs the command if the script file or executable file or input file is newer than the output file.

## Version

0.1

## Author

Eric Pelzer (ecstatic.coder@gmail.com).

## License

This project is licensed under the GNU General Public License version 3.

See the [LICENSE.md](LICENSE.md) file for details.
