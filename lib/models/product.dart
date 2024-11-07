class Product {
  final int id;
  final String nome;
  final String descricao;
  final double preco;
  final int estoque;
  final String data;

  Product({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.estoque,
    required this.data,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      preco: json['preco'] != null ? double.parse(json['preco'].toString()) : 0.0, // Adiciona verificação de null
      estoque: json['estoque'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'estoque': estoque,
      'data': data,
    };
  }
}
