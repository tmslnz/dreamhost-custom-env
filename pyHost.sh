# ##################
# Directory mangling
####################
cd ~
rm -rf downloads
rm -rf opt
mkdir opt downloads
cd opt
mkdir local
chmod 775 ./local
cd local
mkdir lib
chmod 775 ./lib
cd ~

#####################
# Refresh .bashrc
#####################

source ~/.bashrc

# ###################
# Download and unpack
#####################
cd downloads
wget http://www.bzip.org/1.0.5/bzip2-1.0.5.tar.gz
tar -xzf bzip2-1.0.5.tar.gz
wget ftp://ftp.gnu.org/gnu/readline/readline-6.1.tar.gz
tar -xzf readline-6.1.tar.gz
wget http://prdownloads.sourceforge.net/tcl/tcl8.5.8-src.tar.gz
tar -xzf tcl8.5.8-src.tar.gz
wget http://prdownloads.sourceforge.net/tcl/tk8.5.8-src.tar.gz
tar -xzf tk8.5.8-src.tar.gz
wget http://pypi.python.org/packages/source/b/bsddb3/bsddb3-5.0.0.tar.gz
tar -xvf bsddb3-5.0.0
wget http://python.org/ftp/python/2.6.5/Python-2.6.5.tgz
tar -xzf Python-2.6.5.tgz
wget http://download.oracle.com/berkeley-db/db-5.0.21.tar.gz
tar -xzf db-5.0.21.tar.gz
wget http://www.openssl.org/source/openssl-1.0.0.tar.gz
tar -xzf openssl-1.0.0.tar.gz
wget http://www.sqlite.org/sqlite-amalgamation-3.6.23.tar.gz
tar -xzf sqlite-amalgamation-3.6.23.tar.gz
wget http://mercurial.selenic.com/release/mercurial-1.5.2.tar.gz
tar -xzf mercurial-1.5.2.tar.gz
wget http://pypi.python.org/packages/source/v/virtualenv/virtualenv-1.4.8.tar.gz
tar -xzf virtualenv-1.4.8.tar.gz
wget http://www.doughellmann.com/downloads/virtualenvwrapper-2.1.1.tar.gz
tar -xzf virtualenvwrapper-2.1.1.tar.gz

# ##################################################################
# Set temporary session paths for and variables for the GCC compiler
####################################################################
#unset LD_LIBRARY_PATH
#unset LD_RUN_PATH

export LD_LIBRARY_PATH=$HOME/opt/local/lib:$LD_LIBRARY_PATH
export LD_RUN_PATH=$LD_LIBRARY_PATH
export LDFLAGS="-L$HOME/opt/local/lib"
export CPPFLAGS="-I$HOME/opt/local/include -I$HOME/opt/local/include/openssl -I$HOME/opt/local/include/readline"
export CXXFLAGS=$CPPFLAGS
export CFLAGS=$CPPFLAGS

# ###################
# Compile and Install
#####################
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

cd readline-6.1
./configure --prefix=$HOME/opt/local
make
make install
cd ..

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

cd db-5.0.21/build_unix
../dist/configure \
--prefix=$HOME/opt/local \
--enable-tcl \
--with-tcl=$HOME/opt/local/lib
make
make install
# cd $HOME/opt/local/lib
# cp libdb_tcl-5.0.so $HOME/opt/local/lib
# cp libdb-5.0.so $HOME/opt/local/lib
# cd $HOME/opt/local/lib
# rm -f libdb_tcl-5.so
# rm -f libdb_tcl.so
# rm -f libdb-5.so
# rm -f libdb.so
# ln -s libdb_tcl-5.0.so libdb_tcl-5.so
# ln -s libdb_tcl-5.0.so libdb_tcl.so
# ln -s libdb-5.0.so libdb-5.so
# ln -s libdb-5.0.so libdb.so
# cd ~/downloads
cd ../..

cd bzip2-1.0.5
make -f Makefile-libbz2_so
make
make install PREFIX=$HOME/opt/local
cp libbz2.so.1.0.4 $HOME/opt/local/lib
cd $HOME/opt/local/lib
rm -f libbz2.so.1.0
ln -s libbz2.so.1.0.4 libbz2.so.1.0
cd ~/downloads

cd sqlite-3.6.23
./configure --prefix=$HOME/opt/local
make
make install
cd ..

cd Python-2.6.5
./configure --prefix=$HOME/opt/local
make
make install
cd ..

cd mercurial-1.5.2
make install PREFIX=$HOME/opt/local
#python setup.py install --home=$HOME/opt/local
cd ..

# ~/opt/Python-2.6.5/bin/python2.6 virtualenv-1.4.3/virtualenv.py $HOME/opt/local
# easy_install virtualenv
# cd ..
