import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Value of [AuthService.autoCode] when Android verified the number
/// instantly without needing a code.
const String kAutoSignedIn = 'signed-in';

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}

abstract class AuthService {
  bool get isSignedIn;

  /// Phone number of the signed-in user in +<country><number> format.
  String get phone;

  /// Set when the SMS code was detected automatically.
  ValueListenable<String?> get autoCode;

  Future<void> sendOtp(String phone);
  Future<void> verifyOtp(String code);

  /// Name saved for this account, or null if the profile is not set up yet.
  Future<String?> myName();
  Future<void> saveProfile(String name);

  /// Returns {phone: name} for every given phone that has an account.
  Future<Map<String, String>> findRegistered(Iterable<String> phones);
  Future<void> signOut();
}

class FirebaseAuthService implements AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  final ValueNotifier<String?> _autoCode = ValueNotifier<String?>(null);
  String? _verificationId;
  int? _resendToken;

  @override
  ValueListenable<String?> get autoCode => _autoCode;

  @override
  bool get isSignedIn => _auth.currentUser != null;

  @override
  String get phone => _auth.currentUser?.phoneNumber ?? '';

  @override
  Future<void> sendOtp(String phone) {
    _autoCode.value = null;
    final done = Completer<void>();
    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      forceResendingToken: _resendToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        final code = credential.smsCode;
        if (code != null) {
          _autoCode.value = code;
        } else {
          try {
            await _auth.signInWithCredential(credential);
            _autoCode.value = kAutoSignedIn;
          } catch (_) {}
        }
        if (!done.isCompleted) done.complete();
      },
      verificationFailed: (e) {
        if (!done.isCompleted) done.completeError(AuthException(_message(e)));
      },
      codeSent: (id, token) {
        _verificationId = id;
        _resendToken = token;
        if (!done.isCompleted) done.complete();
      },
      codeAutoRetrievalTimeout: (id) => _verificationId = id,
    );
    return done.future;
  }

  @override
  Future<void> verifyOtp(String code) async {
    final id = _verificationId;
    if (id == null) {
      throw AuthException('Please request a new code.');
    }
    try {
      await _auth.signInWithCredential(
        PhoneAuthProvider.credential(verificationId: id, smsCode: code),
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_message(e));
    }
  }

  DocumentReference<Map<String, dynamic>> get _myDoc =>
      _db.collection('registered').doc(phone);

  @override
  Future<String?> myName() async {
    final snap = await _myDoc.get();
    final name = snap.data()?['name'];
    return name is String && name.isNotEmpty ? name : null;
  }

  @override
  Future<void> saveProfile(String name) async {
    final user = _auth.currentUser!;
    await _myDoc.set({
      'uid': user.uid,
      'name': name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await user.updateDisplayName(name);
  }

  @override
  Future<Map<String, String>> findRegistered(Iterable<String> phones) async {
    final list = phones.toList();
    final found = <String, String>{};
    final futures = <Future<void>>[];
    for (var i = 0; i < list.length; i += 30) {
      final chunk = list.sublist(i, i + 30 > list.length ? list.length : i + 30);
      futures.add(
        _db
            .collection('registered')
            .where(FieldPath.documentId, whereIn: chunk)
            .get()
            .then((snap) {
          for (final d in snap.docs) {
            found[d.id] = (d.data()['name'] as String?) ?? '';
          }
        }),
      );
    }
    await Future.wait(futures);
    return found;
  }

  @override
  Future<void> signOut() => _auth.signOut();

  String _message(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'This phone number is not valid.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-verification-code':
        return 'Incorrect code. Please try again.';
      case 'session-expired':
        return 'The code has expired. Please request a new one.';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return '${e.message ?? 'Something went wrong.'} (${e.code})';
    }
  }
}

AuthService authService = FirebaseAuthService();
