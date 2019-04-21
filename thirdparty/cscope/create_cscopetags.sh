#!/bin/sh

#echo off 
# The first parameter passed to the batch file(%1) is the project root directory
# Enter into project root directory before starting the command
CCWD=$1
echo "Enter into project root directory:  $CCWD"
cd $CCWD

echo "Creating cscope.files ..."
INPUTFILE=cscope.files
if [ -f $INPUTFILE ]
then 
	echo "Deleting the existing file: $INPUTFILE"
    rm $INPUTFILE
fi

#echo off
#for /R %%i IN (*.c *.h *.s *.asm) DO (
	#echo %%i>>%INPUTFILE%
#)

IN_DIR=$CCWD
OUT_DIR=$CCWD
find  $IN_DIR                                                                    \
    -name "*.[chxsS]"                                                           \
	-print >$OUT_DIR/cscope.files
if [ -f $INPUTFILE ]
then 
    echo "$INPUTFILE created successfully"
else
    echo "failed to create $INPUTFILE"
fi

#Usage: cscope [-bcCdehklLqRTuUvV] [-f file] [-F file] [-i file] [-I dir] [-s dir]
#              [-p number] [-P path] [-[0-8] pattern] [source files]
#
#-b            Build the cross-reference only.
#-C            Ignore letter case when searching.
#-c            Use only ASCII characters in the cross-ref file (don't compress).
#-d            Do not update the cross-reference.
#-e            Suppress the <Ctrl>-e command prompt between files.
#-F symfile    Read symbol reference lines from symfile.
#-f reffile    Use reffile as cross-ref file name instead of cscope.out.
#-h            This help screen.
#-I incdir     Look in incdir for any #include files.
#-i namefile   Browse through files listed in namefile, instead of cscope.files
#-k            Kernel Mode - don't use /usr/include for #include files.
#-L            Do a single search with line-oriented output.
#-l            Line-oriented interface.
#-num pattern  Go to input field num (counting from 0) and find pattern.
#-P path       Prepend path to relative file names in pre-built cross-ref file.
#-p n          Display the last n file path components.
#-q            Build an inverted index for quick symbol searching.
#-R            Recurse directories for files.
#-s dir        Look in dir for additional source  files.
#-T            Use only the first eight characters to match against C symbols.
#-U            Check file time stamps.
#-u            Unconditionally build the cross-reference file.
#-v            Be more verbose in line mode.
#-V            Print the version number.
#
#Please see the manpage for more information.

echo "Creating cscope tags ..."

#echo off
# Create the new cscope tags file in project root folder:
if [ -f cscope.files ]
then 
    echo "cscope.files exists,create tags based on input file"
    cscope -b -q -k -f cscope_new.out
else
    echo "no input file, search recursively within current folder"
    cscope -R -b -q -k -f cscope_new.out
fi

# Rename the files to its original: cscope.out, cscope.in.out, cscope.po.out
if [ -f cscope.out ]
then 
    echo "Cscope tags updated successfully"
    rm cscope.out
else
    echo "Cscope tags created successfully"
fi

if [ -f cscope.in.out ]
then 
rm cscope.in.out
fi

if [ -f cscope.po.out ]
then 
rm cscope.po.out
fi

mv cscope_new.out     cscope.out
mv cscope_new.out.in  cscope.in.out
mv cscope_new.out.po  cscope.po.out

#pause 
#read -p "press enter to continue"

# Exit the command window automatically when completes
exit

