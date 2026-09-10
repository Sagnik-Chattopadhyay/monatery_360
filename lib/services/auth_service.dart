import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'firestore_service.dart';
import '../models/user_model.dart';
import '../config/firebase_options.dart';

class AuthService {
  final FirestoreService _firestoreService = FirestoreService();
  final fb_auth.FirebaseAuth _fbAuth = fb_auth.FirebaseAuth.instance;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
    String? monasteryAffiliation,
    bool hasAsthma = false,
    bool hasHeartCondition = false,
    bool hasAltitudeSensitivity = false,
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    // 1. Enforce unique email check in Firestore
    final existingDoc = await _firestoreService.getUserByEmail(cleanEmail);
    if (existingDoc != null) {
      throw Exception('Email "$cleanEmail" is already registered. Please Sign In instead.');
    }

    String uid = 'user_${DateTime.now().millisecondsSinceEpoch}';

    if (DefaultFirebaseOptions.useLiveFirebase) {
      try {
        final credential = await _fbAuth.createUserWithEmailAndPassword(
          email: cleanEmail,
          password: password.trim(),
        );
        if (credential.user != null) {
          uid = credential.user!.uid;
          await credential.user!.updateDisplayName(displayName);
        }
      } on fb_auth.FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          throw Exception('This email is already in use. Please Sign In instead.');
        }
        rethrow;
      } catch (e) {
        // Fallback for custom/offline auth
      }
    }

    _currentUser = UserModel(
      uid: uid,
      email: cleanEmail,
      displayName: displayName,
      role: role, // Locked permanently upon sign-up
      monasteryAffiliation: monasteryAffiliation,
      visitedCount: role == UserRole.local ? 25 : 0,
      toursCompleted: role == UserRole.local ? 10 : 0,
      badgesCount: role == UserRole.local ? 15 : 2,
      createdAt: DateTime.now(),
      hasAsthma: hasAsthma,
      hasHeartCondition: hasHeartCondition,
      hasAltitudeSensitivity: hasAltitudeSensitivity,
    );

    // Save User Document to Firebase Cloud Firestore 'users' collection
    await _firestoreService.saveUser(_currentUser!);

    return _currentUser;
  }

  Future<UserModel?> login(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();
    String? uid;

    if (DefaultFirebaseOptions.useLiveFirebase) {
      try {
        final credential = await _fbAuth.signInWithEmailAndPassword(
          email: cleanEmail,
          password: password.trim(),
        );
        if (credential.user != null) {
          uid = credential.user!.uid;
        }
      } catch (e) {
        // Firebase auth check failed or unverified credentials
      }
    }

    // 1. Search existing user document in Firestore by UID
    UserModel? existingUser;
    if (uid != null) {
      existingUser = await _firestoreService.getUser(uid);
    }

    // 2. Fallback search by email
    existingUser ??= await _firestoreService.getUserByEmail(cleanEmail);

    if (existingUser != null) {
      _currentUser = existingUser;
      return _currentUser;
    }

    // 3. DO NOT create a new user on login if user does not exist!
    throw Exception('No account found for "$cleanEmail". Please Sign Up first.');
  }

  Future<UserModel?> updateHealthProfile({
    required bool hasAsthma,
    required bool hasHeartCondition,
    required bool hasAltitudeSensitivity,
  }) async {
    if (_currentUser == null) return null;

    _currentUser = UserModel(
      uid: _currentUser!.uid,
      email: _currentUser!.email,
      displayName: _currentUser!.displayName,
      role: _currentUser!.role,
      monasteryAffiliation: _currentUser!.monasteryAffiliation,
      visitedCount: _currentUser!.visitedCount,
      toursCompleted: _currentUser!.toursCompleted,
      badgesCount: _currentUser!.badgesCount,
      createdAt: _currentUser!.createdAt,
      hasAsthma: hasAsthma,
      hasHeartCondition: hasHeartCondition,
      hasAltitudeSensitivity: hasAltitudeSensitivity,
    );

    await _firestoreService.saveUser(_currentUser!);
    return _currentUser;
  }

  Future<void> signOut() async {
    if (DefaultFirebaseOptions.useLiveFirebase) {
      try {
        await _fbAuth.signOut();
      } catch (_) {}
    }
    _currentUser = null;
  }
}

