//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lixo_sustentavel/models/admin_users_manager.dart';
import 'package:lixo_sustentavel/models/cart_manager.dart';
import 'package:lixo_sustentavel/models/home_manager.dart';
import 'package:lixo_sustentavel/models/product.dart';
import 'package:lixo_sustentavel/models/product_manager.dart';
import 'package:lixo_sustentavel/models/user_manager.dart';
import 'package:lixo_sustentavel/screens/address/address_screen.dart';
import 'package:lixo_sustentavel/screens/base/base_screen.dart';
import 'package:lixo_sustentavel/screens/base/login/login_screen.dart';
import 'package:lixo_sustentavel/screens/cart/cart_screen.dart';
import 'package:lixo_sustentavel/screens/chekout/checkout_screen.dart';
import 'package:lixo_sustentavel/screens/edit_product/edit_product_screen.dart';
import 'package:lixo_sustentavel/screens/product/product_screen.dart';
import 'package:lixo_sustentavel/screens/select_product/select_product_screen.dart';
import 'package:lixo_sustentavel/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());

  //Firestore.instance.collection("novo").add({"teste": "teste"});
  //Firestore.instance.collection("iOS").add({"Olá": "Olá"});
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //Pode ser acessado de qualquer lugar do programa
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          //sempre que o usermanager for modificado ele carra um novo carrinho
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager),
          //.. é a injeçao do conteudo de userManager para cartManager
          //se houver mudança do usuário, o cartManager é avisado (notacao cascata)
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
              adminUsersManager..updateUser(userManager),
        )
      ],
      child: MaterialApp(
        title: 'RCD',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //primarySwatch: Colors.blue,
          primaryColor: Color.fromARGB(255, 4, 125, 141),
          scaffoldBackgroundColor: Color.fromARGB(255, 4, 125, 141),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            elevation: 0,
          ),
        ),
        initialRoute: "/base",
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(
                builder: (_) => LoginScrren(),
              );
            case '/signup':
              return MaterialPageRoute(
                builder: (_) => SignupScreen(),
              );
            case '/product':
              return MaterialPageRoute(
                builder: (_) => ProductScreen(
                  settings.arguments as Product,
                ),
              );
            case '/cart':
              return MaterialPageRoute(
                builder: (_) => CartScreen(),
                settings: settings,
              );
            case '/address':
              return MaterialPageRoute(
                builder: (_) => AddressScreen(),
              );
            case '/checkout':
              return MaterialPageRoute(
                builder: (_) => CheckoutScreen(),
              );
            case '/edit_product':
              return MaterialPageRoute(
                builder: (_) =>
                    EditProductScreen(settings.arguments as Product),
              );
            case '/select_product':
              return MaterialPageRoute(
                builder: (_) => SelectProductScreen(),
              );
            case "/base":
            default:
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
              );
          }
        },
      ),
    );
  }
}
