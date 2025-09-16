import 'dart:convert';

import 'package:http/http.dart' as http;

class ProductService {

 Future<List<Map<String, dynamic>>> getProducts() async {
  final url = Uri.parse('http://localhost:8080/api/products'); 

  final response = await http.get(url);

  if (response.statusCode == 200) {

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => e as Map<String, dynamic>).toList();
  } else {
    throw Exception('Erro ao carregar produtos: ${response.statusCode}');
  }

}
String getImageForCategory(String? categoryName) {
  switch (categoryName?.toLowerCase()) {
    case 'hortifruti':
      return 'images/hortifruit.jpg';
    case 'padaria':
      return 'images/padaria.png';
    case 'laticínios':
      return 'images/laticinios.png';
    default:
      return 'images/product.png'; 
  }
}
}