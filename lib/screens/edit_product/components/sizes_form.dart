import 'package:flutter/material.dart';
import 'package:lixo_sustentavel/common/custom_icon_button.dart';
import 'package:lixo_sustentavel/models/item_size.dart';
import 'package:lixo_sustentavel/models/product.dart';
import 'package:lixo_sustentavel/screens/edit_product/components/edit_item_size.dart';

class SizesForm extends StatelessWidget {
  const SizesForm(this.product);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      //initialValue: List.from(product.sizes),
      initialValue: product.sizes,
      validator: (sizes) {
        if (sizes.isEmpty) {
          return 'Insira um Tamanho';
        }
        return null;
      },
      //a lista é uma referência
      builder: (state) {
        return Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Tamanhos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  onTap: () {
                    state.value.add(ItemSize());
                    state.didChange(state.value);
                  },
                ),
              ],
            ),
            Column(
              children: state.value.map(
                (size) {
                  return EditItemSize(
                    key: ObjectKey(size),
                    size: size,
                    onRemove: () {
                      state.value.remove(size);
                      state.didChange(state.value);
                    },
                    onMoveUp: size != state.value.first
                        ? () {
                            final index = state.value.indexOf(size);
                            state.value.remove(size);
                            state.value.insert(index - 1, size);
                            state.didChange(state.value);
                          }
                        : null,
                    onMoveDown: size != state.value.last
                        ? () {
                            final index = state.value.indexOf(size);
                            state.value.remove(size);
                            state.value.insert(index + 1, size);
                            state.didChange(state.value);
                          }
                        : null,
                  );
                },
              ).toList(),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
