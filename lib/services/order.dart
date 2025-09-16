import 'dart:convert';

import 'package:http/http.dart' as http;

class Order {

 Future<void> postOrder(Map<String, dynamic> request) async {
  final url = Uri.parse('http://localhost:8080/products'); 

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(request),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("Pedido criado com sucesso!");
    print("Resposta: ${response.body}");
  } else {
    print("Erro ao criar pedido: ${response.statusCode}");
    print(response.body);
  }

}
}