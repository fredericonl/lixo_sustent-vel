import 'package:flutter/material.dart';
import 'package:lixo_sustentavel/models/item_size.dart';
import 'package:lixo_sustentavel/models/product.dart';
import 'package:provider/provider.dart';

class SizeWidget extends StatelessWidget {
  const SizeWidget({this.size});
  final ItemSize size;

  @override
  Widget build(BuildContext context) {
    /*consumer.watch é usado para rebuildar apenas widget inteiro se for 
    uma parte do widget, usa o consumer */
    final product = context.watch<Product>();
    final selected = size == product.selectedSize;

    Color color;
    if (!size.hasStock)
      color = Colors.red.withAlpha(50);
    else if (selected)
      color = Theme.of(context).primaryColor;
    else
      color = Colors.grey;

    return GestureDetector(
      onTap: () {
        if (size.hasStock) {
          product.selectedSize = size;
        }
      },
      child: Container(
        //adicionar uma borda em volta do tamanho do produto
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                size.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              //container onde vai ficar o preço
              child: Text(
                'R\$ ${size.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
