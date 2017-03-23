#!/bin/bash

# Moves Booktype core template files from one place to another.
# Why is this useful?
# * backup templates
# * overwrite default templates with new design
#
# Usage:
# Either launch like ./copy_core_templates.sh
# This will prompt you for the paths.
# or
# ./copy_core_templates.sh --in {source path} --out {target path}
# ./copy_core_templates.sh -i {source path} -o {target path}
#
# NOTE: the path is the absolute path down to the lib directory.
# Like this: /home/micz/Documents/github/Booktype/lib


# read parameters from input
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -i|--in)
    SOURCE="$2"
    shift
    ;;
    -o|--out)
    TARGET="$2"
    shift
    ;;
    *)
esac
shift # past argument or value
done

echo Moves Booktype core template files from one place to another.
echo Why is this useful?
echo - backup templates
echo - overwrite default templates with new design
echo

if [ -z "$SOURCE" ]; then
    SOURCE="$HOME/Documents/github/Booktype/lib"
    # Get values from user
    echo Source: copy from \(Hit Enter for \'$SOURCE\'\)
    read INPUT
    if [ -n "$INPUT" ]; then
        SOURCE=$INPUT
    fi
fi

if [ -z "$TARGET" ]; then
    TARGET="$HOME/Documents/github/BooktypeCopy/lib"
    # Get values from user
    echo Target: copy to \(Hit Enter for \'$TARGET\'\)
    read INPUT
    if [ -n "$INPUT" ]; then
        TARGET=$INPUT
    fi
fi

if [ ! -d "$SOURCE" ]; then
  echo $SOURCE does not exist! Exiting script.
  exit 1
fi
if [ ! -d "$TARGET" ]; then
  echo $TARGET does not exist! Will be created.
  mkdir -p $TARGET/booktype/apps/core/templates/
  mkdir -p $TARGET/booktype/apps/core/static/core/
  mkdir -p $TARGET/booktype/apps/portal/templates/
  mkdir -p $TARGET/booktype/apps/portal/static/portal/
fi

cp -r $SOURCE/booktype/apps/core/templates/ $TARGET/booktype/apps/core
cp -r $SOURCE/booktype/apps/core/static/core/ $TARGET/booktype/apps/core/static/
cp -r $SOURCE/booktype/apps/portal/templates/ $TARGET/booktype/apps/portal
cp -r $SOURCE/booktype/apps/portal/static/portal/ $TARGET/booktype/apps/portal/static/
