import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductForm extends StatefulWidget {
  final Product? product; // Produto existente para edição

  ProductForm({this.product});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _service = ProductService();

  // Controladores para os campos do formulário
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.nome;
      _descriptionController.text = widget.product!.descricao;
      _priceController.text = widget.product!.preco.toString();
      _stockController.text = widget.product!.estoque.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id ?? 0, // ID será 0 para novos produtos
        nome: _nameController.text,
        descricao: _descriptionController.text,
        preco: double.parse(_priceController.text),
        estoque: int.parse(_stockController.text),
        data: DateTime.now().toString(), // Adicionando o campo `data` aqui
      );

      try {
        bool isSuccess;
        if (widget.product == null) {
          // Novo produto
          isSuccess = await _service.createProduct(product);
        } else {
          // Atualizar produto existente
          isSuccess = await _service.updateProduct(product.id, product);
        }

        if (isSuccess) {
          Navigator.pop(context, true); // Retorna para a tela anterior após salvar
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar o produto')),
          );
        }
      } catch (error) {
        print('Erro ao salvar o produto: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar o produto')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Novo Produto' : 'Editar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o nome do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira a descrição do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o preço do produto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Insira um preço válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Estoque'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira a quantidade em estoque';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Insira uma quantidade válida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text(widget.product == null ? 'Adicionar Produto' : 'Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
