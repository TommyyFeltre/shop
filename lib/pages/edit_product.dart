import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

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
  bool _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit) {
      final id = ModalRoute.of(context)!.settings.arguments as String;
      if(id.isNotEmpty) {
        _editedProduct = Provider.of<Products>(context, listen: false).findById(id);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': '${_editedProduct.price}',
          'imageUrl': ''
        };
        _imageController.text = _editedProduct.imageUrl;
      }
      
    }
    _isInit = false;
    super.didChangeDependencies();
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
      if( (!_imageController.text.startsWith('http') && !_imageController.text.startsWith('https')) || 
          (!_imageController.text.endsWith('.png') && !_imageController.text.endsWith('.jpg') && !_imageController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if(isValid) {
      return;
    }
    _form.currentState!.save();
    if(_editedProduct.id.isNotEmpty) {
      Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
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
                decoration: const InputDecoration(
                  labelText: 'Title',
                  errorStyle: TextStyle(color: Colors.red)
                ),
                textInputAction: TextInputAction.next,
                initialValue: _initValues['title'],
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if(value != null && value.isEmpty) {
                    return 'Please provide a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id, 
                    title: value!, 
                    description: _editedProduct.description, 
                    price: _editedProduct.price, 
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite
                  );
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price',),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                initialValue: _initValues['price'],
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if(value != null && value.isEmpty) {
                    return 'Please provide a value';
                  }
                  if(double.tryParse(value!) == null) {
                    return 'Please enter a valid value';
                  }
                  if(double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id, 
                    title: _editedProduct.title, 
                    description: _editedProduct.description, 
                    price: double.parse(value!), 
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite
                  );
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description',),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                initialValue: _initValues['description'],
                validator: (value) {
                  if(value != null && value.isEmpty) {
                    return 'Please provide a description';
                  }
                  if(value!.length < 10) {
                    return 'Should be at least 10 characters long.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id, 
                    title: _editedProduct.title, 
                    description: value!, 
                    price: _editedProduct.price, 
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                      _editedProduct = Product(
                        id: _editedProduct.id, 
                        title: _editedProduct.title, 
                        description: _editedProduct.description, 
                        price: _editedProduct.price, 
                        imageUrl: value!,
                        isFavorite: _editedProduct.isFavorite
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