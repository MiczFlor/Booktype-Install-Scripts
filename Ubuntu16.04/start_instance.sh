#!/bin/bash
#
# Start Instance

INSTALLDIR=$HOME"/booktype2"
INSTANCE="mybook"

# Get values from user

clear

echo Path to installation directory? \(Hit Enter for \'$INSTALLDIR\'\)
read INPUT
if [ -n "$INPUT" ]; then
    INSTALLDIR=$INPUT
fi

echo Name of Booktype instance? \(Hit Enter for \'$INSTANCE\'\)
read INPUT
if [ -n "$INPUT" ]; then
    INSTANCE=$INPUT
fi

echo
echo Your settings:
echo 
echo Installation directory : $INSTALLDIR
echo Booktype instance : $INSTANCE
echo 
echo Correct and continue?
ANSWER=("Yes" "No")
select OPT in "${ANSWER[@]}"
do
    case $OPT in
        "Yes")
            # continue
            echo Instance will be started.
            break
            ;;
        "No")
            # Exit script
            echo Exiting script.
            exit 1
            break
            ;;
        *) echo "Invalid selection";;
    esac
done

cd $INSTALLDIR
source venv/bin/activate
cd $INSTANCE
python manage.py runserver