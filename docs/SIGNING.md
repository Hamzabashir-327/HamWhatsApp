# Android app signing

Milestone 1 builds a release APK that uses the default debug signing key. That is fine for installing and testing on your own phone, but not for Play Store release.

To sign properly later:

1. Create a keystore on your own computer (keep it OUT of Git):

       keytool -genkey -v -keystore hamwhatsapp.jks -keyalg RSA -keysize 2048 -validity 10000 -alias hamwhatsapp

2. Store these as GitHub repository secrets (Settings > Secrets and variables > Actions):
   `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`.
3. The workflow decodes the keystore at build time and writes `android/key.properties`.
   (This step is added when signing is wired up.)

Never commit `.jks`, `.keystore`, `key.properties` or passwords. `.gitignore` already blocks them.
