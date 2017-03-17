#!/bin/bash
#
# run this script as sudo

DBNAME="booktype-db"
DBUSER="booktype-user"
INSTALLDIR=$HOME"/booktype2"
GITREPO="https://github.com/sourcefabric/Booktype.git"
INSTANCE="mybook"
MPDFDIR="/var/www/html/mPDF-v6.1.0"

# Get values from user
clear
echo Please provide some information
echo
echo Name of database? \(Hit Enter for \'$DBNAME\'\)
read INPUT
if [ -n "$INPUT" ]; then
    DBNAME=$INPUT
fi
echo Name of database user? \(Hit Enter for \'$DBUSER\'\)
read INPUT
if [ -n "$INPUT" ]; then
    DBUSER=$INPUT
fi
echo Path to installation directory? \(Hit Enter for \'$INSTALLDIR\'\)
read INPUT
if [ -n "$INPUT" ]; then
    INSTALLDIR=$INPUT
fi
echo Git repository URL? \(Hit Enter for \'$GITREPO\'\)
read INPUT
if [ -n "$INPUT" ]; then
    GITREPO=$INPUT
fi
echo Name of Booktype instance? \(Hit Enter for \'$INSTANCE\'\)
read INPUT
if [ -n "$INPUT" ]; then
    INSTANCE=$INPUT
fi
echo Path to mpdf renderer? \(Hit Enter for \'$MPDFDIR\'\)
read INPUT
if [ -n "$INPUT" ]; then
    MPDFDIR=$INPUT
fi

echo
echo Your installation will use:
echo 
echo Database : $DBNAME
echo Database user : $DBUSER
echo Installation directory : $INSTALLDIR
echo Git repository : $GITREPO
echo Booktype instance : $INSTANCE
echo Path to mpdf : $MPDFDIR
echo 
echo Correct and continue?
ANSWER=("Yes" "No")
select OPT in "${ANSWER[@]}"
do
    case $OPT in
        "Yes")
            # continue
            echo Installation will start.
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

# change to installation directory
echo Changing to $INSTALLDIR
cd $INSTALLDIR

# Start virtual environment
source venv/bin/activate

# Create database
cd $INSTANCE
python manage.py migrate

# Create superuser for login
python manage.py createsuperuser

# Update
python manage.py update_permissions
python manage.py update_default_roles

# Start webserver
python manage.py runserver
# This will show the link where you can access Booktype in your browser (http://127.0.0.1:8000/)

# So start the server any time:
# Note: $INSTANCE and $INSTALLDIR need to be replaced with what you set above
#
#    cd $INSTALLDIR
#    source venv/bin/activate
#    cd $INSTANCE
#    python manage.py runserver
