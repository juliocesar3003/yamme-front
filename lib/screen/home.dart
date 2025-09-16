import 'package:flutter/material.dart';
import 'package:yamme/screen/checkout.dart';
import 'package:yamme/services/category.dart';
import 'package:yamme/services/product.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int cartCount = 0;
  int pageVisible = 0;
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  final ProductService productService = ProductService();
  final CategoryService categoryService = CategoryService();
  @override
  void initState() {
    super.initState();
    productService
        .getProducts()
        .then((data) {
          setState(() {
            products = data;
            filteredProducts = List.from(products);
          });
        })
        .catchError((error) {
          print('Erro ao carregar produtos: $error');
        });
    categoryService
        .getCategories()
        .then((data) {
          setState(() {
            categories = data;
          });
        })
        .catchError((error) {
          print('Erro ao carregar categorias: $error');
        });
    setState(() {
      pageVisible = 0;
    });
  }

  void _onChildPressed() {
    if (cartCount > 0) {
      setState(() {
        cartCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _header(),
          if (pageVisible == 0) _body(),
          if (pageVisible == 1)
            Expanded(
              child: Checkout(data: orders, onPressed: _onChildPressed),
            ),
          if (pageVisible == 2) Expanded(child: _loadingScreen()),
        ],
      ),
    );
  }

  Widget _loadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator()],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xff0C544E),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _menu(),
              SizedBox(width: 10),
              _logo(),
              SizedBox(width: 30),
              _search(),
            ],
          ),
          Row(children: [_orders(), SizedBox(width: 10), _profile()]),
        ],
      ),
    );
  }

  Widget _menu() {
    return IconButton(
      icon: Icon(Icons.menu, color: Colors.white, size: 28),
      onPressed: () {},
    );
  }

  Widget _logo() {
    return MouseRegion(
      cursor: SystemMouseCursors
          .click, // muda o cursor para "click" quando estiver sobre a imagem
      child: GestureDetector(
        onTap: () {
          setState(() {
            pageVisible = 0;
          });
        },
        child: Image.asset(
          'images/logo.png',
          width: 50,
          height: 50,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }

  _search() {
    final List<String> options =
        ['Todas'] + categories.map((cat) => cat['name'].toString()).toList();

    return SizedBox(
      width: 400,
      height: 45,
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return options.where(
            (option) => option.toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            ),
          );
        },
        fieldViewBuilder:
            (context, textController, focusNode, onFieldSubmitted) {
              return TextField(
                controller: textController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Pesquise aqui...',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 15,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
              );
            },
        onSelected: (String selection) {
          setState(() {
            if (selection == 'Todas') {
              filteredProducts = List.from(products);
            } else {
              filteredProducts = products
                  .where((prod) => prod['category']['name'] == selection)
                  .toList();
            }
          });
        },
      ),
    );
  }

  _orders() {
    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            icon: Icon(
              Icons.shopping_cart_checkout_outlined,
              color: Colors.teal,
            ),
            onPressed: () {
              _navegateToCheckout();
            },
          ),
        ),
        if (cartCount > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$cartCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  _profile() {
    return IconButton(
      icon: Icon(Icons.person, color: Colors.white),
      onPressed: () {},
    );
  }

  _body() {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: 700,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_banner(), SizedBox(height: 30), _products()],
        ),
      ),
    );
  }

  _banner() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xff0C544E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Bem-vindo ao Yamme!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Encontre as melhores ofertas para você.',
                  style: TextStyle(color: Colors.white70, fontSize: 28),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 167, 221, 104),
                    foregroundColor: const Color.fromARGB(255, 0, 75, 67),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Explore Agora',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Image.asset(
            'images/banner.png',
            width: 300,
            height: 300,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ],
      ),
    );
  }

  _products() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produtos em Destaque',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 0, 51, 43),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return _productCard(filteredProducts[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _productCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.asset(
              productService.getImageForCategory(
                product['category']?['name'],
              ), // você pode trocar por uma URL vinda do back
              width: 150,
              height: 150,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  product['name'], // nome do produto
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  product['category']?['name'] ??
                      '', // mostra categoria se tiver
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  'R\$ ${product['price'].toStringAsFixed(2)}', // preço formatado
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 0, 51, 43),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 30, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      cartCount++;
                      orders.add({
                        'id': product['id'],
                        'nome': product['name'],
                        'quantidade': 1,
                        'preco': product['price'],
                        'category': product['category']?['name'],
                      });
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navegateToCheckout() async {
    setState(() {
      pageVisible = 1;
    });
  }
}
