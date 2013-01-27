TAR=to_win.tar
rm $TAR $TAR.bz2
cd security/
tar --create --exclude='*.CC*' --exclude='*.ACME*' --file=../$TAR --verbose sami-ixp/ucode/common sami-ixp/ucode/csg2 sami-ixp/ucode/li sami-ixp/common/ 
cd ../
tar --append --exclude='*.CC*' --exclude='*.ACME*' --file=$TAR --verbose platform/security/export/itasca
bzip2 -z $TAR
