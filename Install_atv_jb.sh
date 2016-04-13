#!/bin/bash

APPNAME="atvipa"
APPFOLDER="Payload/${APPNAME}.app/"
PROVISION="embedded.mobileprovision"
ENTITLEMENTS="entitlements.plist"
IPA="${APPNAME}.ipa"

if [ "$#" -ne "4" ]; then  
    echo "usage: $0 <udid> <bundle id> <team id> <common name id>"  
    exit 1  
fi  

UDID="$1"
BundleID="$2"
TeamID="$3"
CommonNameID="$4"

defaults write "${PWD}/${ENTITLEMENTS}" "application-identifier" "${TeamID}.${BundleID}"
plutil -convert xml1 "${PWD}/${ENTITLEMENTS}"

defaults write "${PWD}/${APPFOLDER}/Info.plist" "CFBundleIdentifier" "${BundleID}"

cp "${PROVISION}" "${APPFOLDER}embedded.mobileprovision"

codesign --force --sign "${CommonNameID}" --entitlements "${ENTITLEMENTS}" --timestamp=none "${APPFOLDER}"

rm -f "Payload/.DS_Store"
rm -f ${IPA}
zip -qr ${IPA} Payload

echo "resign done"

echo "begin install"

./ideviceinstaller -u "${UDID}" -i ${IPA}
echo "end install"
