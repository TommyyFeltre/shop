import 'package:flutter/material.dart';
import 'package:shop/pages/edit_product.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  const UserProductItem(this.title, this.imageUrl,{super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductPage.routeName);
              },
              icon: const Icon(Icons.edit)
            ),
            IconButton(
              color: Theme.of(context).colorScheme.error,
              onPressed: () {
                
              },
              icon: const Icon(Icons.delete)
            )
          ],
        ),
      ),
    );
  }
}