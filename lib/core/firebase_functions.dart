import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFunctions {
  static createUserWithEmailAndPassword(String emailAddress,
      String password,
      String name,
      Function onSuccess,
      Function onError,) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    } catch (e) {
      onError("something went wrong");
    }
  }

  static LoginWithEmailAndPassword(String emailAddress,
      String password,
      Function onSuccess,
      Function onError,) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    }
  }
}
