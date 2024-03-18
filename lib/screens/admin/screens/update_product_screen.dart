import 'dart:io';


import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:etailor/components/custom_button.dart';
import 'package:etailor/components/custom_textfield.dart';
import 'package:etailor/models/product.dart';
import 'package:etailor/services/admin_services.dart';

import 'package:etailor/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class UpdateProductScreen extends StatefulWidget {
  static const String routeName = '/update-product';
  final Product? product;
  const UpdateProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  final AdminServices adminServices = AdminServices();

  String category = 'widg';
  List<File> images = [];
  final _addProductFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    
  }

  

  List<String> productCategories = [
    'Ideas',
    'Khaadi',
    'MariaB',
    'NishatLinen',
  ];

  void updateProduct() {
    if (_addProductFormKey.currentState!.validate()) {
      adminServices.updateProduct(
        context: context,
        id: widget.product!.id,
        name: productNameController.text,
        price: double.parse(priceController.text),
        quantity: double.parse(quantityController.text),
        category: category,
        images: images,
      );
      // print(productNameController.text);
      // print(priceController.text);
      // print(quantityController.text);
      // print(category);
      // print(images);

    }
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  void setInitial(){
    priceController.text = widget.product!.price.toString();
    quantityController.text = widget.product!.quantity.toString();
    productNameController.text = widget.product!.name;
    category = widget.product!.category;
  }

  @override
  void initState() {
    super.initState();
    setInitial();
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          
          title: const Text(
            'Update Product',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Update Product Images'),
                    IconButton(onPressed: (){
                                  setState(() {
                                    images = [];
                                  });
                                }, icon: const Icon(Icons.cancel)),
                  ],
                ),
                const SizedBox(height: 20),
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images.map(
                          (i) {
                            return Builder(
                              builder: (BuildContext context) => Image.file(
                                i,
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Update Product Images',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      CarouselSlider(
                              items: widget.product?.images.map(
                                (i) {
                                  return Builder(
                                    builder: (BuildContext context) =>
                                        Image.network(
                                      i,
                                      fit: BoxFit.contain,
                                      height: 100.h,
                                    ),
                                  );
                                },
                              ).toList(),
                              options: CarouselOptions(
                                viewportFraction: 1,
                                height: 150.h,
                              ),
                            ),
                SizedBox(height: 30.h),
                CustomTextField(
                  controller: productNameController,
                  keyboardType: TextInputType.text,
                  hintText: 'Product Name',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  hintText: 'Price',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  hintText: 'Quantity',
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: productCategories.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        category = newVal!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Update',
                  onTap: updateProduct,
                  color: Colors.blue,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
