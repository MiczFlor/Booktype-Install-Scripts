#!/bin/bash

# Moves Booktype core template files from one place to another.
# Why is this useful?
# * backup templates
# * overwrite default templates with new design

# Folders needed for theme:
# Booktype/lib/booktype/apps/core/templates/
# Booktype/lib/booktype/apps/core/static/core/

SOURCE="$HOME/Documents/github/Booktype/lib/booktype/apps/core"
TARGET="$HOME/Documents/github/BooktypeCopy/lib/booktype/apps/core"

echo Moves Booktype core template files from one place to another.
echo Why is this useful?
echo * backup templates
echo * overwrite default templates with new design
echo

# Get values from user
echo Source: copy from \(Hit Enter for \'$SOURCE\'\)
read INPUT
if [ -n "$INPUT" ]; then
    SOURCE=$INPUT
fi
echo Target: copy to \(Hit Enter for \'$TARGET\'\)
read INPUT
if [ -n "$INPUT" ]; then
    TARGET=$INPUT
fi

if [ ! -d "$SOURCE" ]; then
  echo $SOURCE does not exist! Exiting script.
  exit 1
fi
if [ ! -d "$TARGET" ]; then
  echo $TARGET does not exist! Will be created.
  mkdir -p $TARGET/templates/
  mkdir -p $TARGET/static/core/
fi

cp -r $SOURCE/templates/ $TARGET
cp -r $SOURCE/static/core/ $TARGET/static/