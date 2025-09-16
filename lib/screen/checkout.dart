import 'package:flutter/material.dart';
import 'package:yamme/services/product.dart';


class Checkout extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final VoidCallback onPressed;
  const Checkout({super.key, required this.data, required this.onPressed});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final ProductService productService = ProductService();
  double get totalPrice {
    return widget.data.fold(
        0, (sum, item) => sum + (item['preco'] * item['quantidade']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 60, vertical: 40),
        child: Container(
          width: double.infinity,
          height: 600,
          decoration: BoxDecoration(
            color: const Color(0xffE6E6E6),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Seu Carrinho',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 20),
          
                Expanded(
                  child: widget.data.isEmpty
                      ? Center(
                          child: Text(
                            'Seu carrinho está vazio 😢',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: widget.data.length,
                          itemBuilder: (context, index) {
                            final item = widget.data[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 0,
                             
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    // Imagem do produto
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                       color: Colors.grey[200],
                                        image:  DecorationImage(
                                          image: AssetImage( productService.getImageForCategory(item['category'])),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    // Nome e quantidade
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['nome'],
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              const Icon(Icons.inventory_2,
                                                  size: 18,
                                                  color: Color(0xff0C544E)),
                                              const SizedBox(width: 5),
                                              Text('Qtd: ${item['quantidade']}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[700])),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'R\$ ${(item['preco'] * item['quantidade']).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff0C544E)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Botões de quantidade
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle,
                                              color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              if (item['quantidade'] > 1) {
                                                item['quantidade']--;
                                                widget.onPressed();
                                              } else {
                                                widget.onPressed();
                                                widget.data.removeAt(index);
                                              }
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle,
                                              color: Colors.green),
                                          onPressed: () {
                                            setState(() {
                                              item['quantidade']++;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
          
                const SizedBox(height: 20),
                
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xff0C544E),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'R\$ ${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Botão finalizar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // ação do checkout
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffA7DD68),
                      foregroundColor: const Color(0xff004B43),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Finalizar Compra',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
