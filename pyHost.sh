cd ~
mkdir opt downloads

cd downloads
wget http://www.bzip.org/1.0.5/bzip2-1.0.5.tar.gz
tar -xzf bzip2-1.0.5.tar.gz
wget ftp://ftp.gnu.org/gnu/readline/readline-6.1.tar.gz
tar -xzf readline-6.1.tar.gz
wget http://prdownloads.sourceforge.net/tcl/tcl8.5.8-src.tar.gz
tar -xzf tcl8.5.8-src.tar.gz
wget http://prdownloads.sourceforge.net/tcl/tk8.5.8-src.tar.gz
tar -xzf tk8.5.8-src.tar.gz
wget http://python.org/ftp/python/2.6.5/Python-2.6.5.tgz
tar -xzf Python-2.6.5.tgz
wget http://download.oracle.com/berkeley-db/db-5.0.21.tar.gz
tar -xzf db-5.0.21.tar.gz
wget http://www.openssl.org/source/openssl-1.0.0.tar.gz
tar -xzf openssl-1.0.0.tar.gz
wget http://www.sqlite.org/sqlite-amalgamation-3.6.23.tar.gz
tar -xzf sqlite-amalgamation-3.6.23.tar.gz

export LD_LIBRARY_PATH=$HOME/opt/local/lib:$HOME/opt/local/BerkeleyDB.5.0/lib
export LD_RUN_PATH=$LD_LIBRARY_PATH
export LDFLAGS="-L$HOME/opt/local/lib -L$HOME/opt/local/BerkeleyDB.5.0/lib"    
export CPPFLAGS="-I$HOME/opt/local/include -I$HOME/opt/local/BerkeleyDB.5.0/include"
export CXXFLAGS=$CPPFLAGS
export CFLAGS=$CPPFLAGS

cd openssl-1.0.0
./config --prefix=$HOME/opt/local --openssldir=$HOME/opt/local/openssl shared 
make 
make install
cd ..

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
--prefix=$HOME/opt/local/BerkeleyDB.5.0 \
--enable-tcl \
--with-tcl=$HOME/opt/local/lib
make
make install
cd ../..

cd bzip2-1.0.5
make
make install PREFIX=$HOME/opt/local
cd ..

cd sqlite-3.6.23
./configure --prefix=$HOME/opt/local
make
make install
cd ..

cd Python-2.6.5
./configure --prefix=$HOME/opt/Python-2.6.5
make
make install
