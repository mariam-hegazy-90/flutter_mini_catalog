import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mini_catalog/product_widgets.dart';

void main() => runApp(const MyApp());

final List<Map<String, dynamic>> kProducts = [
  {"name": "Laptop", "price": 1200, "image": "images/laptop.jpg"},
  {"name": "Phone", "price": 800, "image": "images/phone.jpg"},
  {"name": "Headphones", "price": 150, "image": "images/headphones.jpg"},
  {"name": "Keyboard", "price": 90, "image": "images/keyboard.jpg"},
  {"name": "Mouse", "price": 40, "image": "images/mouse.jpg"},
  {"name": "Monitor", "price": 300, "image": "images/monitor.jpg"},
];

// ---------------- go_router (ACTIVE) ----------------
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) {
        final user = state.uri.queryParameters['user'] ?? 'Guest';
        return ProductsPage(username: user);
      },
    ),
    GoRoute(
      path: '/details/:name/:price',
      name: 'details',
      builder: (context, state) {
        final name = state.pathParameters['name']!;
        final price = state.pathParameters['price']!;
        return DetailsPage(name: name, price: price);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mini Product Catalog',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      routerConfig: _router,
    );
  }
}

/* ---------------- Navigator version (COMMENTED OUT) ----------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/products': (context) {
          final username = ModalRoute.of(context)!.settings.arguments as String;
          return ProductsPage(username: username);
        },
      },
    );
  }
}

// Login button:
//   Navigator.pushNamed(context, '/products', arguments: name);
//
// Products -> Details:
//   final result = await Navigator.push<String>(
//     context,
//     MaterialPageRoute(
//       builder: (_) => DetailsPage(name: p['name'], price: '${p['price']}'),
//     ),
//   );
//   if (result != null) setState(() => _cartMessage = result);
//
// Details "Add to Cart":
//   Navigator.pop(context, '$name added to cart');
------------------------------------------------------------------- */

// ======================= Login =======================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("LoginPage: initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("LoginPage: didChangeDependencies");
  }

  @override
  void deactivate() {
    print("LoginPage: deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("LoginPage: dispose");
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("LoginPage: build");
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final name = _nameController.text.trim().isEmpty
                      ? 'Guest'
                      : _nameController.text.trim();

                  // go_router
                  context.goNamed('products', queryParameters: {'user': name});

                  // Navigator version (commented out):
                  // Navigator.pushNamed(context, '/products', arguments: name);
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================= Products =======================
class ProductsPage extends StatefulWidget {
  final String username;
  const ProductsPage({super.key, required this.username});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int _favorites = 0;
  String _cartMessage = '';
  double _width = 0;

  @override
  void initState() {
    super.initState();
    print("ProductsPage: initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    _width = size.width;
    print(
      "ProductsPage: didChangeDependencies -> width: ${size.width}, height: ${size.height}",
    );
  }

  @override
  void deactivate() {
    print("ProductsPage: deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("ProductsPage: dispose");
    super.dispose();
  }

  void _onFavorite() {
    setState(() => _favorites++);
  }

  Future<void> _onProductTap(int index) async {
    final p = kProducts[index];

    // go_router: push and await the result
    final result = await context.push<String>(
      '/details/${Uri.encodeComponent(p['name'])}/${p['price']}',
    );

    // Navigator version (commented out):
    // final result = await Navigator.push<String>(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => DetailsPage(name: p['name'], price: '${p['price']}'),
    //   ),
    // );

    if (result != null) {
      setState(() => _cartMessage = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("ProductsPage: build");
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  'Welcome, ${widget.username}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text('Favorites: $_favorites'),
                Text('Screen width: ${_width.toStringAsFixed(0)}'),
                if (_cartMessage.isNotEmpty)
                  Text(
                    _cartMessage,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _width < 600
                ? ProductsListView(
                    products: kProducts,
                    onFavoritePressed: _onFavorite,
                    onProductTap: _onProductTap,
                  )
                : ProductsGridView(
                    products: kProducts,
                    onFavoritePressed: _onFavorite,
                    onProductTap: _onProductTap,
                  ),
          ),
        ],
      ),
    );
  }
}

// ======================= Details =======================
class DetailsPage extends StatefulWidget {
  final String name;
  final String price;
  const DetailsPage({super.key, required this.name, required this.price});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    print("DetailsPage: initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("DetailsPage: didChangeDependencies");
  }

  @override
  void deactivate() {
    print("DetailsPage: deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("DetailsPage: dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("DetailsPage: build");
    final imagePath = 'images/${widget.name.toLowerCase()}.jpg';
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, size: 100),
            ),
            const SizedBox(height: 16),
            Text(
              widget.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('Price: \$${widget.price}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // go_router
                context.pop('${widget.name} added to cart');

                // Navigator version (commented out):
                // Navigator.pop(context, '${widget.name} added to cart');
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
