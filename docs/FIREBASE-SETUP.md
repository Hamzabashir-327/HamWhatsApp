# Firebase setup (real SMS OTP + contacts matching)

Android package name: `com.hamwhatsapp.hamwhatsapp`

Fingerprints of the fixed signing key used by the GitHub build:

    SHA1:   2E:74:65:7E:C7:CD:C0:FC:F9:E6:D8:17:8B:9C:44:37:AF:03:43:98
    SHA256: 85:82:D4:F0:A7:DF:97:A3:7E:3E:37:69:B3:A9:19:92:AB:4F:39:47:96:3F:F6:69:B2:93:7F:62:5D:59:80:F1

1. Firebase console > Add project > Add Android app (package name above) > add both fingerprints.
2. Download `google-services.json`.
3. Build > Authentication > Get started > Sign-in method > enable **Phone**.
4. Build > Firestore Database > Create database, then Rules tab: paste `firestore.rules` from this repo and Publish.
5. GitHub repo > Settings > Secrets and variables > Actions > New secret named `GOOGLE_SERVICES_JSON`, paste the whole file content.
6. Actions > Android Build > Run workflow, then install the new APK.

Note: this key is for testing. Create a private key before publishing to Play Store (see SIGNING.md) and add its fingerprints in Firebase too.
