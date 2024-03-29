import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/cart.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/products_grid.dart';

enum FilterOption {
  favorites,
  all
}

class ProductOverview extends StatefulWidget {
  const ProductOverview({super.key});
  static const routeName = '/product-overview';
  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  bool _showFavorites = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if(_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context)
        .getProducts()
        .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption value) {
              setState(() {
                if(value == FilterOption.favorites) {
                _showFavorites  = true;
                } else {
                  _showFavorites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOption.favorites,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOption.all,
                child: Text('Show all'),
              )
            ]
          ),
          Consumer<Cart>(builder: ((_, cart, iconChild) => Badge(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            alignment: Alignment.bottomLeft,
            label: Text(cart .itemCount.toString()),
            child: iconChild,
            )),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
      ? const Center(child: CircularProgressIndicator(),)
      : ProductsGrid(_showFavorites),
    );
  }
}

