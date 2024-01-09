import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

class EditProductPage extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductPage({super.key});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(id: '${DateTime.now()}', title: '', description: '', price: 0, imageUrl: '');

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageController.dispose();
    _form.currentState!.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if(!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title',),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id, 
                    title: value!, 
                    description: _editedProduct.description, 
                    price: _editedProduct.price, 
                    imageUrl: _editedProduct.imageUrl
                  );
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price',),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id, 
                    title: _editedProduct.title, 
                    description: _editedProduct.description, 
                    price: double.parse(value!), 
                    imageUrl: _editedProduct.imageUrl
                  );
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description',),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id, 
                    title: _editedProduct.title, 
                    description: value!, 
                    price: _editedProduct.price, 
                    imageUrl: _editedProduct.imageUrl
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1, 
                        color: Colors.grey
                      )
                    ),
                    child: _imageController.text.isEmpty 
                    ? const Text('Enter a URL') 
                    : FittedBox(
                      child: Image.network(
                        _imageController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageController,
                      focusNode: _imageFocusNode,
                      onSaved: (value) {
                      _editedProduct = Product(
                        id: _editedProduct.id, 
                        title: _editedProduct.title, 
                        description: _editedProduct.description, 
                        price: _editedProduct.price, 
                        imageUrl: value!
                      );
                      },
                      onFieldSubmitted: (_) => _saveForm(),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}