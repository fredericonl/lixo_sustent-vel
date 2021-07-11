import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lixo_sustentavel/helpers/firebase_erros.dart';
import 'package:lixo_sustentavel/models/user.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore fireStore = Firestore.instance;

  User user;

  bool _loading = false;
  bool get loading => _loading;

  bool get isLoggedIn => user != null;

  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      await _loadCurrentUser(firebaseUser: result.user);
      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> signUP({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      user.id = result.user.uid;
      this.user = user;

      await user.saveData();

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser currentUser = firebaseUser ??
        await auth
            .currentUser(); //se verdadeiro pega o FirebaseUser caso falto o currentUser;
    if (currentUser != null) {
      final DocumentSnapshot docUser =
          await fireStore.collection('users').document(currentUser.uid).get();
      user = User.fromDocument(docUser);

      //pegando os dados do aministrador
      final docAdmin =
          await fireStore.collection('admins').document(user.id).get();

      if (docAdmin.exists) {
        user.admin = true;
      }

      notifyListeners();
    }
  }

  Future<void> signOut() async {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  //basta chamar o adminEnabled para saber se o usuário é ou n admin
  bool get adminEnabled => user != null && user.admin;
}
