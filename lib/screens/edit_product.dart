import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/widgets/custom_appbar.dart';

import '../cubits/product/edit_product_cubit.dart';
import '../cubits/product/edit_product_states.dart';
import '../model/product.dart';
import '../services/image_service.dart';
import '../services/product_service.dart';
import '../widgets/custom_message.dart';
import '../widgets/edit_product-form.dart';
import '../layout/main_layout.dart';

class EditProduct extends StatefulWidget {
  final Product product;

  const EditProduct({super.key, required this.product});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  File? _selectedImage;
  String? selectedCategory;
  String?oldImageUrl;
  @override
  void initState() {
    super.initState();
    nameController.text = widget.product.name;
    priceController.text = widget.product.price.toString();
    descriptionController.text = widget.product.description ?? "";
    selectedCategory = widget.product.category;
    oldImageUrl = widget.product.imageUrl;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "تعديل المنتج", centerTitle: true),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocProvider(
          create: (_) => EditProductCubit(ProductService(), ImageService()),
          child: BlocListener<EditProductCubit, EditProductState>(
            listener: (context, state) {
              if (state is EditProductSuccess) {
                ShowAwesomeDialog.success(
                  context,
                  "تم تعديل المنتج بنجاح",
                  onOk: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainLayout()),
                    );
                  },
                );
              } else if (state is EditProductError) {
                ShowAwesomeDialog.error(context, state.message);
              }
            },
            child: Builder(
              builder: (context) {
                final cubit = context.read<EditProductCubit>();
                final state = context.watch<EditProductCubit>().state;
                final isLoading = state is EditProductLoading;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: EditProductForm(
                    imageUrl: oldImageUrl,
                    nameController: nameController,
                    priceController: priceController,
                    descriptionController: descriptionController,
                    selectedImage: _selectedImage,
                    onImagePicked: (image) {
                      setState(() {
                        _selectedImage = image;
                      });
                    },
                    selectedCategory: selectedCategory,
                    onCategoryChanged: (cat) {
                      setState(() {
                        selectedCategory = cat;
                      });
                    },
                    isLoading: isLoading,
                    onSubmit: () {
                      if (selectedCategory == null) {
                        ShowAwesomeDialog.warning(
                          context,
                          "من فضلك اختر صنف المنتج",
                        );
                        return;
                      }

                      cubit.updateProduct(
                        existingProduct: widget.product,
                        name: nameController.text.trim(),
                        description: descriptionController.text.trim(),
                        category: selectedCategory!,
                        price: double.tryParse(priceController.text.trim()) ?? 0.0,
                        image: _selectedImage,

                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
