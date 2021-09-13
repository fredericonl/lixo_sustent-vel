import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:lixo_sustentavel/models/cart_manager.dart';
import 'package:lixo_sustentavel/models/product.dart';
import 'package:lixo_sustentavel/models/user_manager.dart';
import 'package:provider/provider.dart';

import 'components/size_widget.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.name),
          centerTitle: true,
          actions: <Widget>[
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled) {
                  return IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                        '/edit_product',
                        arguments: product,
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: product.images.map(
                  (url) {
                    return NetworkImage(url);
                  },
                ).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ ${product.basePrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Tamanhos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //colocando widget um do lado do outro
                  Wrap(
                    //espaçamento de 8 para cada widget colocado um do lado do outro
                    spacing: 8,
                    runSpacing: 8,
                    children: product.sizes.map(
                      (s) {
                        return SizeWidget(size: s);
                      },
                    ).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //verificar se tem stock para aparecer o botao carrinho
                  if (product.hasStock)
                    //Quando o botao carrinho depender de mais de um estado para esta atividado, usar o consumer 2
                    Consumer2<UserManager, Product>(
                      builder: (_, UserManager, product, __) {
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed:
                                //habilitar botao carrinho caso selecione algum produto, caso contrário fica desabilitado
                                product.selectedSize != null
                                    ? () {
                                        if (UserManager.isLoggedIn) {
                                          context
                                              .read<CartManager>()
                                              .addToCart(product);
                                          Navigator.of(context)
                                              .pushNamed('/cart');
                                        } else {
                                          Navigator.of(context)
                                              .pushNamed('/login');
                                        }
                                      }
                                    : null,
                            color: primaryColor,
                            textColor: Colors.white,
                            child: Text(
                              UserManager.isLoggedIn
                                  ? 'Adicionar ao Carrinho'
                                  : "Entre para Comprar",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
