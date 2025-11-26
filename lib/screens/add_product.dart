import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/product/add_product_cubit.dart';
import '../cubits/product/add_product_state.dart';
import '../layout/main_layout.dart';
import '../services/auth_service.dart';
import '../services/image_service.dart';
import '../services/product_service.dart';
import '../widgets/add_product_form.dart';
import '../widgets/custom_message.dart';
import '../cubits/profile/theme_cubit.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  File? _selectedImage;
  String? selectedCategory;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocProvider(
          create: (context) =>
              AddProductCubit(ProductService(), ImageService(), AuthService()),
          child: BlocListener<AddProductCubit, AddProductState>(
            listener: (context, state) {
              if (state is AddProductSuccess) {
                ShowAwesomeDialog.success(
                  context,
                  "تم إضافة المنتج بنجاح",
                  onOk: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainLayout()),
                    );
                  },
                );
              } else if (state is AddProductFailure) {
                ShowAwesomeDialog.error(context, state.error);
              }
            },
            child: Builder(
              builder: (context) {
                final cubit = context.read<AddProductCubit>();
                final state = context.watch<AddProductCubit>().state;
                final isLoading = state is AddProductLoading;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: AddProductForm(
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
                      if (_selectedImage == null || selectedCategory == null) {
                        ShowAwesomeDialog.warning(
                          context,
                          "من فضلك اختر صورة وصنف للمنتج",
                        );
                        return;
                      }

                      cubit.addProduct(
                        name: nameController.text.trim(),
                        price: priceController.text.trim(),
                        description: descriptionController.text.trim(),
                        category: selectedCategory!,
                        image: _selectedImage!,
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
