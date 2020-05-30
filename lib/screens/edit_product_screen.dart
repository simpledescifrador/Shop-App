import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/models/product.dart';
import 'package:shop_app/models/products.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _descriptionFocusNode = FocusNode();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0.00,
    description: '',
    imageUrl: '',
  );
  final _formKey = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();

  var _isInit = false;

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _titleFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _editedProduct = Provider.of<Products>(
          context,
          listen: false,
        ).getProductById(productId);

        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      _formKey.currentState.validate();
      var imageUrlText = _imageUrlController.text;
      if (imageUrlText.isEmpty ||
          (!imageUrlText.startsWith('http') &&
              !imageUrlText.startsWith('https')) ||
          (!imageUrlText.endsWith('.png') &&
              !imageUrlText.endsWith('.jpg') &&
              !imageUrlText.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _formKey.currentState.validate();

    if (isValid) {
      _formKey.currentState.save();

      if (_editedProduct.id != null) {
        //Edit Product
        Provider.of<Products>(
          context,
          listen: false,
        ).updateProduct(_editedProduct);
      } else {
        //Add New Product
        Provider.of<Products>(
          context,
          listen: false,
        ).addProduct(_editedProduct);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_titleFocusNode);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: _editedProduct.title,
                    decoration: InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    focusNode: _titleFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    onSaved: (value) {
                      _editedProduct.title = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the title.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _editedProduct.price.toStringAsFixed(2),
                    decoration: InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (value) {
                      _editedProduct.price = double.parse(value);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the price.';
                      } else if (double.tryParse(value) == null) {
                        return 'Please enter a valid number.';
                      } else if (double.parse(value) <= 0) {
                        return 'Please enter a number greater than 0.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _editedProduct.description,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    onSaved: (value) {
                      _editedProduct.description = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the description.';
                      } else if (value.length < 10) {
                        return 'Should be at least 10 character long.';
                      }
                      return null;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        margin: EdgeInsets.only(
                          top: 8,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        child: _imageUrlController.text.isEmpty
                            ? Center(child: Text('Enter a URL'))
                            : Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          onSaved: (value) {
                            _editedProduct.imageUrl = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the image url.';
                            } else if (!value.startsWith('http') &&
                                !value.startsWith('https')) {
                              return 'Please enter valid URL.';
                            } else if (!value.endsWith('.png') &&
                                !value.endsWith('.jpg') &&
                                !value.endsWith('.jpeg')) {
                              return 'Please enter a valid image URL.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
