import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:lixo_sustentavel/models/user.dart';
import 'package:lixo_sustentavel/models/user_manager.dart';

class AdminUsersManager extends ChangeNotifier {
  List<User> users = [];
  final Firestore firestore = Firestore.instance;

  //para evitar de atualizar a lista o tempo todo
  StreamSubscription _subscription;

  void updateUser(UserManager userManager) {
    _subscription?.cancel();
    if (userManager.adminEnabled) {
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  //apresenta todos os usuários do firebase para o admin
  void _listenToUsers() {
    //firestore.collection('users').getDocuments().then(
    //se um usuário for adicionado, ele aparece em tempo real, se não quiser, usar linha de cima
    _subscription = firestore.collection('users').snapshots().listen(
      (snapshot) {
        users = snapshot.documents.map((e) => User.fromDocument(e)).toList();
        users.sort(
          (a, b) => a.name.toLowerCase().compareTo(
                b.name.toLowerCase(),
              ),
        );
        notifyListeners();
      },
    );

    //const faker = Faker();
    //for (int i = 0; i < 1000; i++) {
    //  users.add(
    //    User(
    //      name: faker.person.name(),
    //      email: faker.internet.email(),
    //    ),
    //  );
    //}
    //ordenando a lista de usuários por nome e em ordem alfabética
  }

  List<String> get names => users.map((e) => e.name).toList();

  @override
  void dispose() {
    //?. se for nulo ele não da o cancel, por isso usa o ?
    _subscription?.cancel();
    super.dispose();
  }
}
