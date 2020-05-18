#!/bin/sh

# shellcheck disable=SC2164
cd source

wget --quiet https://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2
wget --quiet http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz
wget --quiet https://ftp.postgresql.org/pub/source/v${POSTGRESQL_VERSION}/postgresql-${POSTGRESQL_VERSION}.tar.gz
wget --quiet http://postgis.net/stuff/postgis-${POSTGIS_VERSION}.tar.gz
wget --quiet http://www.cmake.org/files/v3.9/cmake-${CMAKE_VERSION}.tar.gz
wget --quiet http://sourceforge.net/projects/boost/files/boost/1.69.0/boost_1_69_0.tar.gz
tar -xf geos-${GEOS_VERSION}.tar.bz2
tar -zxf gdal-${GDAL_VERSION}.tar.gz
tar -zxf postgresql-${POSTGRESQL_VERSION}.tar.gz
tar -zxf postgis-${POSTGIS_VERSION}.tar.gz
tar -zxf boost_1_69_0.tar.gz
tar -zxf cmake-${CMAKE_VERSION}.tar.gz

cd ${ROOTDIR}
tar -xf mapnik-v3.0.22.tar.bz2
tar -zxf python-mapnik-3.0.16.tar.gz

yum -y install bzip2-devel libpng-devel libjpeg-turbo-devel jbigkit-libs libtiff libtiff-devel \
               xz-devel python-backports python-ipaddress python-backports-ssl_match_hostname \
               python-setuptools python-nose python-devel proj proj-devel proj-epsg proj-nad \
               freetype freetype-devel libicu libicu-devel ncurses-devel readline-devel \
               tcl tcl-devel gdbm-devel libdb-devel pyparsing systemtap-sdt-devel perl \
               perl-libs perl-ExtUtils-Install perl-Test-Harness perl-ExtUtils-Manifest \
               perl-Carp perl-Encode perl-Exporter perl-File-Path perl-File-Temp perl-Filter perl-threads-shared \
               perl-Getopt-Long perl-HTTP-Tiny perl-PathTools perl-Pod-Escapes perl-Pod-Perldoc perl-threads \
               perl-Pod-Simple perl-Pod-Usage perl-Scalar-List-Utils perl-Socket perl-Storable perl-podlators \
               perl-Text-ParseWords perl-Time-HiRes perl-Time-Local perl-constant perl-macros perl-parent \
               keyutils-libs-devel libcom_err-devel libkadm5 pcre-devel libsepol-devel \
               libselinux-devel libverto-devel krb5-devel pam-devel cyrus-sasl cyrus-sasl-devel \
               openldap openldap-devel openssl-devel libgpg-error-devel libgcrypt-devel \
               libxslt libxml2-devel libxslt-devel uuid uuid-devel perl-ExtUtils-Embed pam_krb5 \
               krb5-libs krb5-workstation sqlite sqlite-devel libcurl libcurl-devel fontpackages-filesystem \
               dejavu-fonts-common dejavu-sans-fonts fontconfig libX11-common libXau libxcb libX11 libXfixes \
               libXdamage libXext libXrender libXxf86vm libglvnd mesa-libglapi libwayland-server libwayland-client \
               mesa-libgbm mesa-libEGL libxshmfence libglvnd-egl mesa-libGL libglvnd-glx pixman cairo expat-devel \
               libuuid-devel fontconfig-devel gl-manpages glib2-devel xorg-x11-proto-devel libXau-devel \
               libxcb-devel libX11-devel libXfixes-devel libXdamage-devel libXext-devel libglvnd-core-devel \
               libglvnd-gles libglvnd-opengl libglvnd-devel mesa-libEGL-devel mesa-libGL-devel pixman-devel \
               cairo-devel pycairo pycairo-devel libwebp libwebp-devel swig systemd-devel giflib-devel \
               docbook-style-xsl docbook-utils source-highlight gtk-doc poppler poppler-devel java java-devel \
               xml-commons-apis xml-commons-resolver xalan-j2 xerces-j2 ant json-c-devel protobuf-c protobuf \
               protobuf-compiler protobuf-devel protobuf-lite protobuf-c-compiler protobuf-c-devel \
               graphite2 graphite2-devel harfbuzz harfbuzz-icu harfbuzz-devel xerces-c xerces-c-devel \
               python2-scons google-noto-fonts-common google-noto-sans-fonts google-noto-cjk-fonts \
               google-noto-emoji-fonts nhn-nanum-fonts-common nhn-nanum-brush-fonts nhn-nanum-gothic-fonts \
               nhn-nanum-myeongjo-fonts nhn-nanum-pen-fonts apr apr-devel apr-util apr-util-devel httpd-tools \
               mailcap httpd httpd-devel m4 perl-Data-Dumper autoconf perl-Thread-Queue automake libtool \
               autogen-libopts libtool-ltdl gc guile autogen numpy libquadmath libgfortran lapack atlas blas \
               zlib-devel lua-devel python-yaml python-lxml

# shellcheck disable=SC2164
cd ${ROOTDIR}/rpm
yum -y localinstall CharLS-1.0-5.el7.x86_64.rpm CharLS-devel-1.0-5.el7.x86_64.rpm pyproj-1.9.2-6.20120712svn300.el7.x86_64.rpm \
                    python2-pip-8.1.2-10.el7.noarch.rpm

cd ${ROOTDIR}/source/cmake-${CMAKE_VERSION}
./bootstrap
make -j8
make -j8 install

# shellcheck disable=SC2164
cd ${ROOTDIR}/source/geos-${GEOS_VERSION}
./configure --enable-python --disable-static
make -j8
make -j8 install

# shellcheck disable=SC2164
cd ${ROOTDIR}/source/postgresql-${POSTGRESQL_VERSION}
./configure --enable-depend --enable-nls=ko --with-openssl \
            --with-tcl --with-python --with-gssapi --with-ldap \
            --with-pam --with-libxml --with-selinux --with-systemd \
            --with-libxslt --with-zlib --with-ossp-uuid
make all -j8
make -j8 install
# shellcheck disable=SC2164
cd contrib
make all -j8
make -j8 install

export LD_LIBRARY_PATH=/usr/local/pgsql/lib:${LD_LIBRARY_PATH}
export PKG_CONFIG_PATH=/usr/local/pgsql/lib/pkgconfig
export PATH=/usr/local/pgsql/bin:${PATH}

# shellcheck disable=SC2164
cd ${ROOTDIR}/source/gdal-${GDAL_VERSION}
./configure --with-libtiff --with-geotiff=internal \
            --with-jpeg --with-png --with-libz \
            --with-threads --with-python --with-geos \
            --with-pg --with-java --with-poppler \
            --with-expat --with-sqlite3 --with-proj --enable-shared
make -j8
make -j8 install

export GDAL_DATA=/usr/local/share/gdal

# shellcheck disable=SC2164
cd swig/python
python setup.py build
python setup.py install
# shellcheck disable=SC2164
cd samples
python gdalinfo.py --formats

# shellcheck disable=SC2164
cd ${ROOTDIR}/source/postgis-${POSTGIS_VERSION}
./configure --with-pgconfig=/usr/local/pgsql/bin/pg_config --with-gdalconfig=/usr/local/bin/gdal-config \
            --with-geosconfig=/usr/local/bin/geos-config
make -j8
make -j8 install

cd ${ROOTDIR}/source/boost_1_69_0
./bootstrap.sh
./b2 -d1 -j4 --with-thread --with-filesystem --with-python --with-regex -sHAVE_ICU=1 --with-program_options --with-system link=shared release toolset=gcc stage
./b2 -j4 --with-thread --with-filesystem --with-python --with-regex -sHAVE_ICU=1 --with-program_options --with-system link=shared release toolset=gcc install
bash -c "echo '/usr/local/lib' > /etc/ld.so.conf.d/boost.conf"
ldconfig

export BOOST_PYTHON_LIB=boost_python27
export BOOST_THREAD_LIB=boost_thread
export BOOST_SYSTEM_LIB=boost_system
export LDFLAGS="-L/usr/lib64"

export BOOST_INCLUDES=/usr/local/include
export BOOST_LIBS=/usr/local/lib
export PROJ_LIBS=/usr/lib64
export PROJ_INCLUDES=/usr/include
export GDAL_CONFIG=/usr/local/bin/gdal-config
export PYTHON=/usr/bin/python

# shellcheck disable=SC2164
cd ${ROOTDIR}/mapnik-v3.0.22
git submodule update --init
./configure PKG_CONFIG_PATH=${PKG_CONFIG_PATH} BOOST_INCLUDES=${BOOST_INCLUDES} BOOST_LIBS=${BOOST_LIBS} \
      OPTIMIZATION=3 CAIRO=True SVG_RENDERER=True SVG2PNG=True PYTHON=${PYTHON} GDAL_CONFIG=${GDAL_CONFIG} \
      PROJ_LIBS=${PROJ_LIBS} PROJ_INCLUDES=${PROJ_INCLUDES} DEMO=True
make -j8
make -j8 install

export MAPNIK_INPUT_PLUGINS_DIRECTORY=/usr/local/lib/mapnik/input
export MAPNIK_FONT_DIRECTORY=/usr/local/lib/mapnik/fonts

cd /usr/local/lib/mapnik
rm -rf ./fonts
ln -sf /usr/share/fonts ./

cd ${ROOTDIR}/python-mapnik-3.0.16
PYCAIRO=true python setup.py develop
PYCAIRO=true python setup.py develop install

cd ${ROOTDIR}/python-mapnik-3.0.16/demo/python
python rundemo.py

cd ${ROOTDIR}/mod_tile
./autogen.sh
./configure
make -j8
make -j8 install
make -j8 install-mod_tile
ldconfig

yum -y install osm2pgsql

yum install -y nodejs
npm install -g carto

cmake --version
proj
geos-config --version
gdal-config --version
mapnik-config --version
osm2pgsql --version
carto -v

cd ${ROOTDIR}

mkdir -p /var/run/renderd
chown apache:apache /var/run/renderd
chown -R apache:apache /var/www
chmod -R 777 /var/run/renderd

cp ./20-mod_tile.conf /etc/httpd/conf.modules.d/
cp ./mod_tile.conf /etc/httpd/conf.d/
cp ./httpd.conf /etc/httpd/conf/
