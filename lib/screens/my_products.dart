import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/constants/app_colors.dart';
import 'package:project/cubits/user/user_cubit.dart';
import 'package:project/model/product.dart';
import 'package:project/services/product_service.dart';
import 'package:project/widgets/category_selector.dart';
import 'package:project/widgets/custom_message.dart';
import 'package:project/widgets/product_card.dart';
import '../cubits/product/products_cubit.dart';
import '../cubits/profile/theme_cubit.dart';
import '../widgets/custom_message_yes_or_no.dart';

class MyProducts extends StatefulWidget {
  final String searchQuery;
  final void Function(String)? onSearchChanged;
  const MyProducts({super.key, required this.searchQuery, this.onSearchChanged});

  @override
  State<MyProducts> createState() => MyProductsState();
}

class MyProductsState extends State<MyProducts> {
  String selectedCategory = "All";
  ProductService _productService=ProductService();
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts([String? sellerId]) {
    final userId = sellerId ?? context.read<UserCubit>().user?.uid;
    if (userId == null) return;
    context.read<ProductsCubit>().getMyProducts(
      category: selectedCategory,
      sellerId: userId,
    );
  }


  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state;

    final user = context.read<UserCubit>().user;

    if (user == null) {
      return Center(child: Text("Please log in first"));
    }
    return Column(
      children: [
        CategorySelector(
          categories: const [
            "All",
            "Cables & Chargers",
            "Cases & Protection",
            "Headphones",
            "Screen Protectors",
            "Power Banks",
            "Car Accessories",
          ],
          onCategorySelected: (selected) {
            setState(() {
              selectedCategory = selected;
            });
            _loadProducts();
          },
        ),
        Expanded(
          child: BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is ProductsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductsSuccess) {
                final filtered = state.products.where((p) =>
                    p.name.toLowerCase().contains(widget.searchQuery.toLowerCase())
                ).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    return ProductCard(
                      imageUrl: product.imageUrl,
                      name: product.name,
                      rating: product.rating,
                      reviews: product.reviews,
                      price: product.price,
                      isVendor: true,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/edit_product',
                          arguments: {'product': product},
                        );
                      },
                      onEdit: () {
                        Navigator.pushNamed(
                          context,
                          '/edit_product',
                          arguments: {'product': product},
                        );
                      },
                      onDelete: () {
                        CustomMessageYesOrNo(
                          dialogType: DialogType.warning,
                          title: "Delete Product",
                          description: "Are you sure you want to delete this product?",
                          btnOkOnPress: () async {
                            await _productService.deleteProduct(product.id!);
                            ShowAwesomeDialog.success(context, 'تم حذف المنتج بنجاح.');
                            _loadProducts();
                          },
                          btnCancelOnPress: () {},
                        ).show(context);
                      },
                    );
                  },
                );
              } else if (state is ProductsError ) {
                final message =  state.message;
                return Center(child: Text(message));
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}