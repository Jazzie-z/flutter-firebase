import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = new GoogleSignIn();
  //user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
//        .map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

//sign in anonymous
  Future signInAnonymous() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//sign in email
  Future signIn(String email, String pass) async {
    try {
      AuthResult result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  //sign in with google
  Future signInWithGoogle() async {
    try{
      GoogleSignInAccount result = await _googleAuth.signIn();
      GoogleSignInAuthentication googlekey = await result.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googlekey.accessToken,
        idToken: googlekey.idToken,
      );
      final AuthResult authResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = authResult.user;
      await DatabaseService(uid:user.uid).updateUserData('0', 'new', 100);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e);
      return null;
    }
  }

//register
  Future registerWithEmailPass(String email, String pass) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      FirebaseUser user = result.user;
      //create new documnet for the registered user
      await DatabaseService(uid:user.uid).updateUserData('0', 'new', 100);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

//signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
