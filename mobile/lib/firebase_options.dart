import 'package:firebase_core/firebase_core.dart';

/// Values come from the GOOGLE_SERVICES_JSON GitHub secret at build time
/// (see docs/FIREBASE-SETUP.md). Nothing secret is stored in the repo.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_APP_ID');
    const senderId = String.fromEnvironment('FIREBASE_SENDER_ID');
    const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
    const bucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
    if (apiKey.isEmpty || appId.isEmpty || projectId.isEmpty) {
      throw StateError(
        'Firebase is not configured. Add the GOOGLE_SERVICES_JSON secret '
        'in GitHub and run the build again.',
      );
    }
    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: senderId,
      projectId: projectId,
      storageBucket: bucket.isEmpty ? null : bucket,
    );
  }
}
