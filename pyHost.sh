#!/bin/bash
# =================================================
# = pyHost version 1.1
# = 
# = Created by Tommaso Lanza, under the influence
# = of the guide published by Andrew Watts at:
# = http://andrew.io/weblog/2010/02/installing-python-2-6-virtualenv-and-VirtualEnvWrapper-on-dreamhost/
# =
# = This script automates the installation, download and
# = compiling of Python, Mercurial, VirtualEnv in the home folder.
# = It includes a number of dependencies needed by some Python modules.
# = It has been tested on Dreamhost on a shared server running Debian.
# = It should work with other hosts, but it hasn't been tested.
# = 
# = tmslnz, May 2010
# =================================================

# ##################
# Directory mangling
####################
# First, set your variables here in case you
# want different versions or directories:

# Directory to store the source archives
pH_DL=downloads

# Directory to install these packages
pH_install=opt

# Package versions
#
# Comment out anything you don't want to install...
# ...if you are really sure you already have all 
# necessary libraries installed already.

pH_Python=2.6.5
pH_Mercurial=1.5.2
pH_Git=1.7.1
pH_Django=1.1.1
pH_VirtualEnv=1.4.8
pH_VirtualEnvWrapper=2.1.1
PH_SSL=1.0.0
pH_Readline=6.1
pH_Tcl=8.5.8
pH_Tk=8.5.8
pH_Berkeley_47x=4.7.25
pH_Berkeley_48x=4.8.30
pH_Berkeley_50x=5.0.21
pH_BZip=1.0.5
pH_SQLite=3.6.23
pH_cURL=7.20.1




# Sets the correct version of Berkeley DB to use and download
# by looking at the Python version number
if [[ ${pH_Python:0:3} == "2.6" ]]; then
    pH_Berkeley=$pH_Berkeley_47x
elif [[ ${pH_Python:0:3} == "2.7" ]]; then
    pH_Berkeley=$pH_Berkeley_48x
elif [[ ${pH_Python:0:1} == "3" ]]; then
    pH_Berkeley=$pH_Berkeley_50x
fi

# Let's see how long it takes to finish. Go!
start_time=$(date +%s)

# Make a backup copy of the current ~/$pH_install folder by renaming it.
cd ~
cp --archive $pH_install $pH_install.backup
mkdir --parents $pH_install $pH_DL
mkdir --parents --mode=775 --verbose $pH_install/local/lib

#####################
# Refresh .bashrc
#
# Let's make sure the variables are 
# updated in case you didn't log out.
#####################
source ~/.bashrc

#####################
# Backup and modify .bashrc
#####################
cp .bashrc .bashrc-backup
cat >> ~/.bashrc <<DELIM


######################################################################
# The following lines were added by the script pyHost.sh from:
# http://bitbucket.org/tmslnz/python-dreamhost-batch/src/tip/pyHost.sh
# on $(date -u)
######################################################################
export PATH=\$HOME/$pH_install/local/bin:\$HOME/$pH_install/Python-$pH_Python/bin:\$HOME/$pH_install/db-$pH_Berkeley/bin:\$PATH

export PYTHONPATH=\$HOME/$pH_install/local/lib/python${pH_Python:0:3}/site-packages:\$PYTHONPATH

DELIM
source ~/.bashrc

# ###################
# Download and unpack
#####################
cd ~/$pH_DL
wget http://pypi.python.org/packages/source/b/bsddb3/bsddb3-5.0.0.tar.gz
rm -rf bsddb3-5.0.0
tar -xvf bsddb3-5.0.0.tar.gz




# GCC
# ##################################################################
# Set temporary session paths for and variables for the GCC compiler
# 
# Specify the right version of Berkeley DB you want to use, see
# below for DB install scripts.
####################################################################
export LD_LIBRARY_PATH=\
$HOME/$pH_install/local/lib:\
$HOME/$pH_install/db-$pH_Berkeley/lib:\
$LD_LIBRARY_PATH

export LD_RUN_PATH=$LD_LIBRARY_PATH

export LDFLAGS="\
-L$HOME/$pH_install/db-$pH_Berkeley/lib \
-L$HOME/$pH_install/local/lib"

export CPPFLAGS="\
-I$HOME/$pH_install/local/include \
-I$HOME/$pH_install/local/include/openssl \
-I$HOME/$pH_install/db-$pH_Berkeley/include \
-I$HOME/$pH_install/local/include/readline"

export CXXFLAGS=$CPPFLAGS
export CFLAGS=$CPPFLAGS

# Append Berkeley DB to EPREFIX. Used by Python setup.py
export EPREFIX=$HOME/$pH_install/db-$pH_Berkeley/lib:$EPREFIX




# ############################
# Download Compile and Install
##############################

# OpenSSL (required by haslib)
function ph_openssl {
    cd ~/$pH_DL
    wget http://www.openssl.org/source/openssl-$PH_SSL.tar.gz
    rm -rf openssl-$PH_SSL
    tar -xzf openssl-$PH_SSL.tar.gz
    cd openssl-$PH_SSL
    ./config --prefix=$HOME/$pH_install/local --openssldir=$HOME/$pH_install/local/openssl shared 
    make
    make install
    cp libcrypto.so.$PH_SSL $HOME/$pH_install/local/lib/
    cp libssl.so.$PH_SSL $HOME/$pH_install/local/lib/
    cd $HOME/$pH_install/local/lib
    rm -f libcrypto.so
    rm -f libssl.so
    ln -s libcrypto.so.$PH_SSL libcrypto.so
    ln -s libssl.so.$PH_SSL libssl.so
}

# Readline
function ph_readline {
    cd ~/$pH_DL
    wget ftp://ftp.gnu.org/gnu/readline/readline-$pH_Readline.tar.gz
    rm -rf readline-$pH_Readline
    tar -xzf readline-$pH_Readline.tar.gz
    cd readline-$pH_Readline
    ./configure --prefix=$HOME/$pH_install/local
    make
    make install
}

# Tcl/Tk
function ph_tcltk {
    cd ~/$pH_DL
    wget http://prdownloads.sourceforge.net/tcl/tcl$pH_Tcl-src.tar.gz
    rm -rf tcl$pH_Tcl-src
    tar -xzf tcl$pH_Tcl-src.tar.gz
    wget http://prdownloads.sourceforge.net/tcl/tk$pH_Tk-src.tar.gz
    rm -rf tk$pH_Tk-src
    tar -xzf tk$pH_Tk-src.tar.gz
    cd tcl$pH_Tcl/unix
    ./configure --prefix=$HOME/$pH_install/local
    make
    make install
    cd ../..
    cd tk$pH_Tk/unix
    ./configure --prefix=$HOME/$pH_install/local
    make
    make install
    cd ../..
    rm -f $HOME/$pH_install/local/lib/libtcl${pH_Tcl:0:1}.so
    rm -f $HOME/$pH_install/local/lib/libtcl.so
    rm -f $HOME/$pH_install/local/lib/libtk${pH_Tk:0:1}.so
    rm -f $HOME/$pH_install/local/lib/libtk.so
    ln -s $HOME/$pH_install/local/lib/libtcl${pH_Tcl:0:3}.so $HOME/$pH_install/local/lib/libtcl${pH_Tcl:0:1}.so
    ln -s $HOME/$pH_install/local/lib/libtcl${pH_Tcl:0:3}.so $HOME/$pH_install/local/lib/libtcl.so
    ln -s $HOME/$pH_install/local/lib/libtk${pH_Tk:0:3}.so $HOME/$pH_install/local/lib/libtk${pH_Tk:0:1}.so
    ln -s $HOME/$pH_install/local/lib/libtk${pH_Tk:0:3}.so $HOME/$pH_install/local/lib/libtk.so
}

# Oracle Berkeley DB
function ph_berkeley {
    cd ~/$pH_DL
    wget http://download.oracle.com/berkeley-db/db-$pH_Berkeley.tar.gz
    rm -rf db-$pH_Berkeley
    tar -xzf db-$pH_Berkeley.tar.gz
    cd db-$pH_Berkeley/build_unix
    ../dist/configure \
    --prefix=$HOME/$pH_install/db-$pH_Berkeley \
    --enable-tcl \
    --with-tcl=$HOME/$pH_install/local/lib
    make
    make install
}

# Bzip (required by hgweb)
function ph_bzip {
    cd ~/$pH_DL
    wget http://www.bzip.org/$pH_BZip/bzip2-$pH_BZip.tar.gz
    rm -rf bzip2-$pH_BZip
    tar -xzf bzip2-$pH_BZip.tar.gz
    cd bzip2-$pH_BZip
    make -f Makefile-libbz2_so
    make
    make install PREFIX=$HOME/$pH_install/local
    cp libbz2.so.${pH_BZip:0:3}.4 $HOME/$pH_install/local/lib
    rm -f $HOME/$pH_install/local/lib/libbz2.so.${pH_BZip:0:3}
    ln -s $HOME/$pH_install/local/lib/libbz2.so.${pH_BZip:0:3}.4 $HOME/$pH_install/local/lib/libbz2.so.${pH_BZip:0:3}
}

# SQLite
function ph_sqlite {
    cd ~/$pH_DL
    wget http://www.sqlite.org/sqlite-amalgamation-$pH_SQLite.tar.gz
    rm -rf sqlite-amalgamation-$pH_SQLite
    tar -xzf sqlite-amalgamation-$pH_SQLite.tar.gz
    cd sqlite-$pH_SQLite
    ./configure --prefix=$HOME/$pH_install/local
    make
    make install
}

# Python
function ph_python {
    cd ~/$pH_DL
    wget http://python.org/ftp/python/$pH_Python/Python-$pH_Python.tgz
    rm -rf Python-$pH_Python
    tar -xzf Python-$pH_Python.tgz
    cd Python-$pH_Python
    ./configure --prefix=$HOME/$pH_install/Python-$pH_Python
    make
    make install
}

# Mercurial
function ph_mercurial {
    cd ~/$pH_DL
    wget http://mercurial.selenic.com/release/mercurial-$pH_Mercurial.tar.gz
    rm -rf mercurial-$pH_Mercurial
    tar -xzf mercurial-$pH_Mercurial.tar.gz
    cd mercurial-$pH_Mercurial
    make install PREFIX=$HOME/$pH_install/local
}

# VirtualEnv
function ph_virtualenv {
    cd ~/$pH_DL
    wget http://pypi.python.org/packages/source/v/virtualenv/virtualenv-$pH_VirtualEnv.tar.gz
    rm -rf virtualenv-$pH_VirtualEnv
    tar -xzf virtualenv-$pH_VirtualEnv.tar.gz
    cd virtualenv-$pH_VirtualEnv
    # May need to use 'python2.5' instead of 'python' here
    # as the script may require a *system* installation of python
    python virtualenv.py $HOME/$pH_install/local
    easy_install virtualenv
    cd ..

    wget http://www.doughellmann.com/downloads/virtualenvwrapper-$pH_VirtualEnvWrapper.tar.gz
    rm -rf virtualenvwrapper-$pH_VirtualEnvWrapper
    tar -xzf virtualenvwrapper-$pH_VirtualEnvWrapper.tar.gz
    cd virtualenvwrapper-$pH_VirtualEnvWrapper
    python setup.py install
    cp virtualenvwrapper.sh $HOME/$pH_install/
    mkdir $HOME/.virtualenvs

    # Virtualenv to .bashrc
    cat >> ~/.bashrc <<DELIM
# Virtualenv wrapper script
export WORKON_HOME=\$HOME/.virtualenvs
source \$HOME/$pH_install/VirtualEnvWrapper.sh
DELIM
    source ~/.bashrc
}

# Django framework
function ph_django {
    cd ~/$pH_DL
    cd $HOME/$pH_DL
    wget http://www.djangoproject.com/download/$pH_Django/tarball/
    rm -rf Django-$pH_Django
    tar -xzf Django-$pH_Django.tar.gz
    cd Django-$pH_Django
    python setup.py install
}

# cURL (for Git to pull remote repos)
function ph_curl {
    cd ~/$pH_DL
    wget http://curl.haxx.se/download/curl-$pH_cURL.tar.gz
    rm -rf curl-$pH_cURL
    tar -xzf curl-$pH_cURL.tar.gz
    cd curl-$pH_cURL
    ./configure --prefix=$HOME/$pH_install/local
    make
    make install
}

# Git
# NO_MMAP is needed to prevent Dreamhost killing git processes
function ph_git {
    cd ~/$pH_DL
    wget http://kernel.org/pub/software/scm/git/git-$pH_Git.tar.gz
    rm -rf git-$pH_Git
    tar -xzf git-$pH_Git.tar.gz
    cd git-$pH_Git
    ./configure --prefix=$HOME/$pH_install/local NO_MMAP=1
    make
    make install
}

# Go!
if test "${PH_SSL+set}" == set ; then
    ph_openssl
fi
if test "${pH_Readline+set}" == set ; then
    ph_readline
fi
if test "${pH_Tcl+set}" == set ; then
    ph_tcltk
fi
if test "${pH_Berkeley+set}" == set ; then
    ph_berkeley
fi
if test "${pH_BZip+set}" == set ; then
    ph_bzip
fi
if test "${pH_SQLite+set}" == set ; then
    ph_sqlite
fi
if test "${pH_Python+set}" == set ; then
    ph_python
fi
if test "${pH_Mercurial+set}" == set ; then
    ph_mercurial
fi
if test "${pH_VirtualEnv+set}" == set ; then
    ph_virtualenv
fi
if test "${pH_Django+set}" == set ; then
    ph_django
fi
if test "${pH_cURL+set}" == set ; then
    ph_curl
fi
if test "${pH_Git+set}" == set ; then
    ph_git
fi


cd ~
finish_time=$(date +%s)
echo "pyHost.sh completed the installation in $((finish_time - start_time)) seconds."