export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppBatteryManagerDemo1
keytool -genkey -v -keystore appbatterymanagerdemo1-release.keystore -alias appbatterymanagerdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppBatteryManagerDemo1/keytool_input.txt
