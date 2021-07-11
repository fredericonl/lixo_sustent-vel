import 'package:flutter/material.dart';
import 'package:lixo_sustentavel/common/common_drawer/custom_drawer.dart';
import 'package:lixo_sustentavel/models/page_manager.dart';
import 'package:lixo_sustentavel/models/user_manager.dart';
import 'package:lixo_sustentavel/screens/admin_users/admin_users_screen.dart';
import 'package:lixo_sustentavel/screens/home/home_screen.dart';
import 'package:lixo_sustentavel/screens/products/products_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            children: <Widget>[
              HomeScreen(),
              ProductsScreen(),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  backgroundColor: Colors.red,
                  title: const Text('Home3'),
                  centerTitle: true,
                  actions: <Widget>[],
                ),
              ),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  backgroundColor: Colors.red,
                  title: const Text('Loja'),
                  centerTitle: true,
                  actions: <Widget>[],
                ),
              ),

              //se administrador for abilitado, adicionar essas duas novas abas

              if (userManager.adminEnabled) ...[
                AdminUsersScreen(),
                Scaffold(
                  drawer: CustomDrawer(),
                  appBar: AppBar(
                    title: const Text('Pedidos'),
                    centerTitle: true,
                  ),
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}
