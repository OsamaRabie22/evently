import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFunctions {
  static Future<void> createUserWithEmailAndPassword(
      String emailAddress,
      String password,
      String name,
      Function onSuccess,
      Function onError,
      ) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      // ✅ بعد ما عمل الـ account، احفظ الاسم
      await credential.user?.updateDisplayName(name);

      // ✅ اعمل reload عشان الـ currentUser يتحدث فوراً
      await credential.user?.reload();

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    } catch (e) {
      onError("something went wrong");
    }
  }

  static Future<void> loginWithEmailAndPassword(
      String emailAddress,
      String password,
      Function onSuccess,
      Function onError,
      ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    }
  }
}