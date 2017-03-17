#!/bin/bash
#
# run this script as sudo

DBNAME="booktype-db"
DBUSER="booktype-user"
INSTALLDIR=$HOME"/booktype2"
GITREPO="https://github.com/sourcefabric/Booktype.git"
INSTANCE="mybook"
MPDFDIR="/var/www/html/mPDF-v6.1.0"
MPDFINSTALL="No"

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
echo Download and install mpdf?
ANSWER=("Yes" "No")
select MPDFINSTALL in "${ANSWER[@]}"
do
    case $MPDFINSTALL in
        "Yes")
            # continue
            echo Mpdf will be installed.
            break
            ;;
        "No")
            # Exit script
            echo Mpdf will not be installed.
            break
            ;;
        *) echo "Invalid selection";;
    esac
done
echo
echo Your installation will use:
echo 
echo Database : $DBNAME
echo Database user : $DBUSER
echo Installation directory : $INSTALLDIR
echo Git repository : $GITREPO
echo Booktype instance : $INSTANCE
echo Path to mpdf : $MPDFDIR
echo Install mpdf? : $MPDFINSTALL
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

# Write variable to file to be read from other script(s)

# install from apt-get
sudo apt-get install postgresql git-core python-dev python-pip libjpeg-dev libpq-dev libxml2-dev libxslt-dev rabbitmq-server redis-server tidy calibre 

# create postgresql booktype user
echo Creating new user in database.
echo Please provide password.
sudo -u postgres createuser -SDRP $DBUSER
# now you will be prompted for a password

# create postgresql database
echo Creating database
sudo -u postgres createdb -E utf8 -T template0 -O $DBUSER $DBNAME

# restart postgresql
sudo service postgresql restart

# download and install MPDF renderer
if [ $MPDFINSTALL = "Yes" ]; then
    echo Installing mpdf
    cd /tmp
    sudo wget https://github.com/mpdf/mpdf/releases/download/v6.1.0/01-mPDF-v6.1.0.zip
    sudo mkdir $MPDFDIR
    sudo unzip 01-mPDF-v6.1.0.zip -d $MPDFDIR
fi

# Create directory for your installation, if non-existent
if [ ! -d "$INSTALLDIR" ]; then
    echo Creating directory $INSTALLDIR;
    sudo mkdir -p $INSTALLDIR;
fi
echo Changing to $INSTALLDIR
cd $INSTALLDIR

# Create new virtual environment
echo Creating virtual environment
virtualenv venv

# Start virtual environment
source venv/bin/activate

# Clone Booktype repo
echo Clonging git repo $GITREPO
git clone $GITREPO

# Install Booktype
pip install -r Booktype/requirements/dev.txt

# install drivers for postgrelsq
pip install -r Booktype/requirements/prod.txt

# to see what's installed, type: pip freeze

# create instance
echo Creating instance $INSTANCE
./Booktype/scripts/createbooktype --database postgresql $INSTANCE

echo
echo "--------------------------------------
Now Change settings manually

1. base file

    sudo nano ${INSTALLDIR}/${INSTANCE}/${INSTANCE}_site/settings/base.py
    
    ADMINS = (
        # ('Your Name', 'your_email@domain.com'),
    )

    MPDF_DIR = '/var/www/html/mPDF-v6.1.0'
    PROFILE_ACTIVE = 'dev'
    BOOKTYPE_SITE_NAME = 'Booktype site'
    DEFAULT_PUBLISHER = "mpdf"


2. dev file

    sudo nano ${INSTALLDIR}/${INSTANCE}/${INSTANCE}_site/settings/dev.py

    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql_psycopg2',
            'NAME': '${DBNAME}',
            'USER': '${DBUSER}',
            'PASSWORD': 'password-db',
            'HOST': 'localhost',
            'PORT': '',
        }
    }
    
    # And in the same change these settings    
    
    MPDF_DIR = '${MPDFDIR}'
    MPDF_SCRIPT = '${INSTALLDIR}/${INSTANCE}/booktype2mpdf.php'
    
"
