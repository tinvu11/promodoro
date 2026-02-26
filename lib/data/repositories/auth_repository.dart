// import 'dart:developer';
//
// import 'package:firebase_auth/firebase_auth.dart';
//
// /// Repository quản lý xác thực Firebase.
// /// Hiện tại hỗ trợ đăng nhập ẩn danh (anonymous sign-in).
// class AuthRepository {
//   final FirebaseAuth _auth;
//
//   AuthRepository({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;
//
//   /// Người dùng hiện tại (null nếu chưa đăng nhập).
//   User? get currentUser => _auth.currentUser;
//
//   /// Đăng nhập ẩn danh.
//   /// - Nếu đã có user đang đăng nhập → giữ nguyên, không tạo mới.
//   /// - Nếu chưa → gọi `signInAnonymously()` để tạo tài khoản ẩn danh.
//   Future<User?> signInAnonymously() async {
//     try {
//       if (_auth.currentUser != null) {
//         log('[Auth] Already signed in: uid=${_auth.currentUser!.uid}');
//         return _auth.currentUser;
//       }
//
//       final credential = await _auth.signInAnonymously();
//       log('[Auth] Anonymous sign-in success: uid=${credential.user?.uid}');
//       return credential.user;
//     } on FirebaseAuthException catch (e) {
//       log('[Auth] Anonymous sign-in failed: ${e.code} - ${e.message}');
//       return null;
//     } catch (e) {
//       log('[Auth] Anonymous sign-in error: $e');
//       return null;
//     }
//   }
//
//   /// Stream theo dõi trạng thái đăng nhập.
//   Stream<User?> get authStateChanges => _auth.authStateChanges();
//
//   /// Đăng xuất.
//   Future<void> signOut() async {
//     await _auth.signOut();
//     log('[Auth] Signed out');
//   }
// }
