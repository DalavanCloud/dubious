#!/bin/sh
OUTDIR=`pwd`/build
WEB_INF_LIB=`pwd`/WEB-INF/lib

### Construct what we need to set the classpath
SDK_DIR="/usr/local/appengine-java-sdk-1.3.4"
SERVLET="$SDK_DIR/lib/shared/geronimo-servlet_2.5_spec-1.2.jar"
SDK_API="$SDK_DIR/lib/user/appengine-api-1.0-sdk-1.3.4.jar"
DBMODEL="$WEB_INF_LIB/dubydatastore.jar"
#COMMONS="/usr/local/apache/commons-io-1.4.jar"

### Generate class files
mkdir -p $OUTDIR
mkdir -p $WEB_INF_LIB
script/environment.rb # copy dubydatastore.jar (unless exists)
CP=$SERVLET:$SDK_API:$OUTDIR:$DBMODEL:.
cd lib
javac -classpath $CP -d $OUTDIR testing/Dir.java
javac -classpath $CP -d $OUTDIR testing/SimpleJava.java
dubyc -c $CP -d $OUTDIR testing/SimpleDuby.duby
dubyc -c $CP -d $OUTDIR stdlib/array.duby
dubyc -c $CP -d $OUTDIR stdlib/io.duby
dubyc -c $CP -d $OUTDIR dubious/action_controller.duby
cd ../app
dubyc -c $CP -d $OUTDIR controllers/application_controller.duby
dubyc -c $CP -d $OUTDIR controllers/shout_controller.duby
dubyc -c $CP -d $OUTDIR controllers/source_controller.duby
dubyc -c $CP -d $OUTDIR controllers/info_properties_controller.duby
cd $OUTDIR
jar -cf ../WEB-INF/lib/application.jar *
cd ..
