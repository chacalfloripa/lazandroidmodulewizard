export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatContinuousScrollableImageViewDemo1
jarsigner -verify -verbose -certs /android/workspace/AppCompatContinuousScrollableImageViewDemo1/bin/AppCompatContinuousScrollableImageViewDemo1-release.apk
