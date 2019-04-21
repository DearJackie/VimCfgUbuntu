
:: The first parameter passed to the batch file(%1) is the project root directory(full path)
:: Enter into project root directory before starting the command
@ECHO OFF
SET CCWD=%1
@ECHO Enter into project root directory:  %CCWD%
CD %CCWD%

@ECHO Creating ctags ...

@ECHO OFF

REM Usage: ctags [options] [file(s)]

  REM -a   Append the tags to an existing tag file.
  REM -B   Use backward searching patterns (?...?).
  REM -e   Output tag file for use with Emacs.
  REM -f <name>
       REM Write tags to specified file. Value of "-" writes tags to stdout
       REM ["tags"; or "TAGS" when -e supplied].
  REM -F   Use forward searching patterns (/.../) (default).
  REM -h <list>
       REM Specify list of file extensions to be treated as include files.
       REM [".h.H.hh.hpp.hxx.h++"].
  REM -I <list|@file>
       REM A list of tokens to be specially handled is read from either the
       REM command line or the specified file.
  REM -L <file>
       REM A list of source file names are read from the specified file.
       REM If specified as "-", then standard input is read.
  REM -n   Equivalent to --excmd=number.
  REM -N   Equivalent to --excmd=pattern.
  REM -o   Alternative for -f.
  REM -R   Equivalent to --recurse.
  REM -u   Equivalent to --sort=no.
  REM -V   Equivalent to --verbose.
  REM -x   Print a tabular cross reference file to standard output.
  REM --append=[yes|no]
       REM Should tags should be appended to existing tag file [no]?
  REM --etags-include=file
      REM Include reference to 'file' in Emacs-style tag file (requires -e).
  REM --exclude=pattern
      REM Exclude files and directories matching 'pattern'.
  REM --excmd=number|pattern|mix
       REM Uses the specified type of EX command to locate tags [mix].
  REM --extra=[+|-]flags
      REM Include extra tag entries for selected information (flags: "fq").
  REM --fields=[+|-]flags
      REM Include selected extension fields (flags: "afmikKlnsStz") [fks].
  REM --file-scope=[yes|no]
       REM Should tags scoped only for a single file (e.g. "static" tags
       REM be included in the output [yes]?
  REM --filter=[yes|no]
       REM Behave as a filter, reading file names from standard input and
       REM writing tags to standard output [no].
  REM --filter-terminator=string
       REM Specify string to print to stdout following the tags for each file
       REM parsed when --filter is enabled.
  REM --format=level
       REM Force output of specified tag file format [2].
  REM --help
       REM Print this option summary.
  REM --if0=[yes|no]
       REM Should C code within #if 0 conditional branches be parsed [no]?
  REM --<LANG>-kinds=[+|-]kinds
       REM Enable/disable tag kinds for language <LANG>.
  REM --langdef=name
       REM Define a new language to be parsed with regular expressions.
  REM --langmap=map(s)
       REM Override default mapping of language to source file extension.
  REM --language-force=language
       REM Force all files to be interpreted using specified language.
  REM --languages=[+|-]list
       REM Restrict files scanned for tags to those mapped to langauges
       REM specified in the comma-separated 'list'. The list can contain any
       REM built-in or user-defined language [all].
  REM --license
       REM Print details of software license.
  REM --line-directives=[yes|no]
       REM Should #line directives be processed [no]?
  REM --links=[yes|no]
       REM Indicate whether symbolic links should be followed [yes].
  REM --list-kinds=[language|all]
       REM Output a list of all tag kinds for specified language or all.
  REM --list-languages
       REM Output list of supported languages.
  REM --list-maps=[language|all]
       REM Output list of language mappings.
  REM --options=file
       REM Specify file from which command line options should be read.
  REM --recurse=[yes|no]
       REM Recurse into directories supplied on command line [no].
  REM --regex-<LANG>=/line_pattern/name_pattern/[flags]
       REM Define regular expression for locating tags in specific language.
  REM --sort=[yes|no|foldcase]
       REM Should tags be sorted (optionally ignoring case) [yes]?.
  REM --tag-relative=[yes|no]
       REM Should paths be relative to location of tag file [no; yes when -e]?
  REM --totals=[yes|no]
       REM Print statistics about source and tag files [no].
  REM --verbose=[yes|no]
       REM Enable verbose messages describing actions on each source file.
  REM --version
       REM Print version identifier to standard output.

@ECHO OFF

:: Create the new Ctags file to project root folder(the current folder)
ctags.exe --recurse=yes -f tags.new --exclude=.git

:: Repgag file with the new tag file
IF EXIST tags (
    DEL tags
    ECHO Ctags tag file updated successfully
) ELSE (
    ECHO Ctags tag file generated successfully
)
RENAME tags.new tags

::PAUSE 

:: Exit the command window automatically when completes
EXIT

