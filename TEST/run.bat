echo "input" > input.txt
del /q output.txt
echo "output" > output.txt
..\forge copy input.txt output.txt
..\forge copy input.txt output.txt
echo "input" > input.txt
..\forge copy input.txt output.txt
..\forge @from:run.bat @:copy @in:input.txt @out:output.txt
echo "input file" > "input file.txt"
del /q "output file.txt"
echo "output file" > "output file.txt"
..\forge copy "input file.txt" "output file.txt"
..\forge copy "input file.txt" "output file.txt"
echo "input file" > "input file.txt"
..\forge copy "input file.txt" "output file.txt"
..\forge @from:run.bat @:copy @in:"input file.txt" @out:"output file.txt"
pause
