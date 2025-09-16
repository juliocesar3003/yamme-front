import 'dart:convert';

import 'package:http/http.dart' as http;

class CategoryService {

 Future<List<Map<String, dynamic>>> getCategories() async {
  final url = Uri.parse('http://localhost:8080/api/categories'); 
  final response = await http.get(url);

  if (response.statusCode == 200) {

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => e as Map<String, dynamic>).toList();
  } else {
    throw Exception('Erro ao carregar produtos: ${response.statusCode}');
  }

}
}