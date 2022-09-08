#!/bin/bash
rpm -e mariadb-libs --nodeps
tar zxf mysql-5.7.35-linux-glibc2.12-x86_64.tar.gz
mv mysql-5.7.35-linux-glibc2.12-x86_64 /usr/local/mysql 
groupadd -r mysql && useradd -r -g mysql -s /bin/false -M mysql
mkdir /usr/local/mysql/data
chown -R mysql:mysql /usr/local/mysql
cat > /etc/my.cnf <<EOF
[mysqld]
basedir=/usr/local/mysql
datadir=/usr/local/mysql/data
pid-file=/usr/local/mysql/data/mysqld.pid
log-error=/usr/local/mysql/data/mysql.err
socket=/tmp/mysql.sock
EOF
echo "export PATH=$PATH:/usr/local/mysql/bin" >> /etc/profile
source /etc/profile
mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
sed  -i  's/^basedir=/basedir=\/usr\/local\/mysql/'  /etc/init.d/mysqld
sed  -i  's/^datadir=/datadir=\/usr\/local\/mysql\/data/'  /etc/init.d/mysqld
chmod  755 /etc/init.d/mysqld
/etc/init.d/mysqld start
/etc/init.d/mysqld stop
b=`grep  'temporary password'   /usr/local/mysql/data/mysql.err`
a=`echo ${b##*localhost:}`
echo $a
/etc/init.d/mysqld start
mysql -uroot -p"${a}" -e  "ALTER USER 'root'@'localhost'  IDENTIFIED  BY '123.com'"  --connect-expired-password
mysql -uroot -p123.com

