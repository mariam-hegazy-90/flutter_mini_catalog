import 'package:flutter/material.dart';

class ProductsListView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final void Function() onFavoritePressed;
  final void Function(int index) onProductTap;

  ProductsListView({
    required this.products,
    required this.onFavoritePressed,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductTile(
          name: products[index]["name"],
          price: products[index]["price"],
          image: products[index]["image"],
          onFavoritePressed: onFavoritePressed,
          onTap: () {
            onProductTap(index);
          },
        );
      },
    );
  }
}

class ProductsGridView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final void Function() onFavoritePressed;
  final void Function(int index) onProductTap;

  ProductsGridView({
    required this.products,
    required this.onFavoritePressed,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
      ),
      itemBuilder: (context, index) {
        return ProductTile(
          name: products[index]["name"],
          price: products[index]["price"],
          image: products[index]["image"],
          onFavoritePressed: onFavoritePressed,
          onTap: () {
            onProductTap(index);
          },
        );
      },
    );
  }
}

class ProductTile extends StatelessWidget {
  final String name;
  final int price;
  final String? image;
  final void Function() onFavoritePressed;
  final void Function() onTap;

  ProductTile({
    required this.name,
    required this.price,
    this.image,
    required this.onFavoritePressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: image == null
            ? null
            : Image.asset(image!, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(name),
        subtitle: Text("\$$price"),
        trailing: IconButton(
          icon: Icon(Icons.favorite),
          color: Colors.red,
          onPressed: onFavoritePressed,
        ),
        onTap: onTap,
      ),
    );
  }
}
