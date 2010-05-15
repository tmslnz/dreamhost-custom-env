#!/bin/bash
# =================================================
# = Created by Tommaso Lanza, under the influence
# = of the guide published by Andrew Watts at:
# = http://andrew.io/weblog/2010/02/installing-python-2-6-virtualenv-and-virtualenvwrapper-on-dreamhost/
# =
# = This script automates the installation, download and
# = compiling of Python, Mercurial, VirtualEnv in the home folder.
# = It includes a number of dependencies needed by some Python modules.
# = It has been tested on Dreamhost on a shared server running Debian.
# = It should work with other hosts, but it hasn't been tested.
# = 
# = tmslnz, May 2010
# =================================================

# Update your .bashrc with the following before running the script:
#   
#   export PATH=\
#   $HOME/opt/local/bin:\
#   $HOME/opt/Python-2.6.5/bin:\
#   $HOME/opt/db-4.7.25/bin:\
#   $PATH
#   # For other Berkeley DB versions use this on the above PATH:
#   # $HOME/opt/db-5.0.21/bin:\
#   # $HOME/opt/db-4.8.30/bin:\
#   
#   export PYTHONPATH=\
#   $HOME/opt/local/lib/python2.6/site-packages:\
#   $PYTHONPATH
#   
# Add this to the .bashrc file after the script has finished
#   # Virtualenv wrapper script
#   export WORKON_HOME=$HOME/.virtualenvs
#   source $HOME/opt/virtualenvwrapper.sh

# ##################
# Directory mangling
####################
cd ~
# Make a backup copy of the current ~/opt folder by renaming it.
mv --interactive opt opt.backup
mkdir opt downloads
mkdir --parents --mode=775 --verbose opt/local/lib

#####################
# Refresh .bashrc
#
# Let's make sure the variables are 
# updated in case you didn't log out.
#####################
source ~/.bashrc

# ###################
# Download and unpack
#####################
cd downloads
wget http://www.bzip.org/1.0.5/bzip2-1.0.5.tar.gz
rm -rf bzip2-1.0.5
tar -xzf bzip2-1.0.5.tar.gz
wget ftp://ftp.gnu.org/gnu/readline/readline-6.1.tar.gz
rm -rf readline-6.1
tar -xzf readline-6.1.tar.gz
wget http://prdownloads.sourceforge.net/tcl/tcl8.5.8-src.tar.gz
rm -rf tcl8.5.8-src
tar -xzf tcl8.5.8-src.tar.gz
wget http://prdownloads.sourceforge.net/tcl/tk8.5.8-src.tar.gz
rm -rf tk8.5.8-src
tar -xzf tk8.5.8-src.tar.gz
wget http://pypi.python.org/packages/source/b/bsddb3/bsddb3-5.0.0.tar.gz
rm -rf bsddb3-5.0.0
tar -xvf bsddb3-5.0.0.tar.gz
wget http://python.org/ftp/python/2.6.5/Python-2.6.5.tgz
rm -rf Python-2.6.5
tar -xzf Python-2.6.5.tgz
wget http://download.oracle.com/berkeley-db/db-5.0.21.tar.gz
rm -rf db-5.0.21
tar -xzf db-5.0.21.tar.gz
wget http://download.oracle.com/berkeley-db/db-4.8.30.tar.gz
rm -rf db-4.8.30
tar -xzf db-4.8.30.tar.gz
wget http://download.oracle.com/berkeley-db/db-4.7.25.tar.gz
rm -rf db-4.7.25
tar -xzf db-4.7.25.tar.gz
wget http://www.openssl.org/source/openssl-1.0.0.tar.gz
rm -rf openssl-1.0.0
tar -xzf openssl-1.0.0.tar.gz
wget http://www.sqlite.org/sqlite-amalgamation-3.6.23.tar.gz
rm -rf sqlite-amalgamation-3.6.23
tar -xzf sqlite-amalgamation-3.6.23.tar.gz
wget http://mercurial.selenic.com/release/mercurial-1.5.2.tar.gz
rm -rf mercurial-1.5.2
tar -xzf mercurial-1.5.2.tar.gz
wget http://pypi.python.org/packages/source/v/virtualenv/virtualenv-1.4.8.tar.gz
rm -rf virtualenv-1.4.8
tar -xzf virtualenv-1.4.8.tar.gz
wget http://www.doughellmann.com/downloads/virtualenvwrapper-2.1.1.tar.gz
rm -rf virtualenvwrapper-2.1.1
tar -xzf virtualenvwrapper-2.1.1.tar.gz
wget http://www.djangoproject.com/download/1.1.1/tarball/
rm -rf Django-1.1.1
tar -xzf Django-1.1.1.tar.gz

# ##################################################################
# Set temporary session paths for and variables for the GCC compiler
# 
# Specify the right version of Berkeley DB you want to use, see
# below for DB install scripts.
####################################################################

# GCC
export LD_LIBRARY_PATH=\
$HOME/opt/local/lib:\
$HOME/opt/db-4.7.25/lib:\
$LD_LIBRARY_PATH

export LD_RUN_PATH=$LD_LIBRARY_PATH

export LDFLAGS="\
-L$HOME/opt/db-4.7.25/lib \
-L$HOME/opt/local/lib"

export CPPFLAGS="\
-I$HOME/opt/local/include \
-I$HOME/opt/local/include/openssl \
-I$HOME/opt/db-4.7.25/include \
-I$HOME/opt/local/include/readline"

export CXXFLAGS=$CPPFLAGS
export CFLAGS=$CPPFLAGS

# Append Berkeley DB to EPREFIX. Used by Python setup.py
export EPREFIX=$HOME/opt/db-4.7.25/lib:$EPREFIX

# ###################
# Compile and Install
#####################

# OpenSSL (required for haslib)
cd openssl-1.0.0
./config --prefix=$HOME/opt/local --openssldir=$HOME/opt/local/openssl shared 
make
make install
cp libcrypto.so.1.0.0 $HOME/opt/local/lib/
cp libssl.so.1.0.0 $HOME/opt/local/lib/
cd $HOME/opt/local/lib
rm -f libcrypto.so
rm -f libssl.so
ln -s libcrypto.so.1.0.0 libcrypto.so
ln -s libssl.so.1.0.0 libssl.so
cd ~/downloads

# Readline
cd readline-6.1
./configure --prefix=$HOME/opt/local
make
make install
cd ..

# Tcl/Tk
cd tcl8.5.8/unix
./configure --prefix=$HOME/opt/local
make
make install
cd ../..
cd tk8.5.8/unix
./configure --prefix=$HOME/opt/local
make
make install
cd ../..
rm -f $HOME/opt/local/lib/libtcl8.so
rm -f $HOME/opt/local/lib/libtcl.so
rm -f $HOME/opt/local/lib/libtk8.so
rm -f $HOME/opt/local/lib/libtk.so
ln -s $HOME/opt/local/lib/libtcl8.5.so $HOME/opt/local/lib/libtcl8.so
ln -s $HOME/opt/local/lib/libtcl8.5.so $HOME/opt/local/lib/libtcl.so
ln -s $HOME/opt/local/lib/libtk8.5.so $HOME/opt/local/lib/libtk8.so
ln -s $HOME/opt/local/lib/libtk8.5.so $HOME/opt/local/lib/libtk.so


## Oracle Berkeley DB 5.0.x for Python 3
#cd db-5.0.21/build_unix
#../dist/configure \
#--prefix=$HOME/opt/db-5.0.21 \
#--enable-tcl \
#--with-tcl=$HOME/opt/local/lib
#make
#make install
#cd ../..
#
## Oracle Berkeley DB 4.8.x for Python 2.7.x
#cd db-4.8.30/build_unix
#../dist/configure \
#--prefix=$HOME/opt/db-4.8.30 \
#--enable-tcl \
#--with-tcl=$HOME/opt/local/lib
#make
#make install
#cd ../..

# Oracle Berkeley DB 4.7.x for Python 2.6.x
cd db-4.7.25/build_unix
../dist/configure \
--prefix=$HOME/opt/db-4.7.25 \
--enable-tcl \
--with-tcl=$HOME/opt/local/lib
make
make install
cd ../..

# Bzip (required by hgweb)
cd bzip2-1.0.5
make -f Makefile-libbz2_so
make
make install PREFIX=$HOME/opt/local
cp libbz2.so.1.0.4 $HOME/opt/local/lib
rm -f $HOME/opt/local/lib/libbz2.so.1.0
ln -s $HOME/opt/local/lib/libbz2.so.1.0.4 $HOME/opt/local/lib/libbz2.so.1.0
cd ..

# SQLite
cd sqlite-3.6.23
./configure --prefix=$HOME/opt/local
make
make install
cd ..

# Python
cd Python-2.6.5
./configure --prefix=$HOME/opt/Python-2.6.5
make
make install
cd ..

# And finally... Mercurial
cd mercurial-1.5.2
make install PREFIX=$HOME/opt/local
cd ..

# And VirtualEnv
cd virtualenv-1.4.8
# May need to use 'python2.5' instead of 'python' here
# as the script may require a *system* installation of python
python virtualenv.py $HOME/opt/local
easy_install virtualenv
cd ..

cd virtualenvwrapper-2.1.1
python setup.py install
cp virtualenvwrapper.sh $HOME/opt/
mkdir $HOME/.virtualenvs
cd ..

cd Django-1.1.1
python setup.py install

cd ~