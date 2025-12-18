import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/widgets/custom_message.dart';
import 'package:project/widgets/image_uploader.dart';
import '../../constants/app_colors.dart';
import '../cubits/profile/theme_cubit.dart';
import 'custom _textfield.dart';
import 'custom_button.dart';
import 'gap.dart';

class AddProductForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final File? selectedImage;
  final Function(File) onImagePicked;
  final String? selectedCategory;
  final Function(String?) onCategoryChanged;
  final VoidCallback onSubmit;
  final bool isLoading;
  const AddProductForm({
    super.key,
    required this.nameController,
    required this.priceController,
    required this.descriptionController,
    required this.selectedImage,
    required this.onImagePicked,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onSubmit, required this.isLoading,
  });

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();

  final List<String> categories = const [
    "Cables & Chargers",
    "Cases & Protection",
    "Headphones",
    "Screen Protectors",
    "Power Banks",
    "Car Accessories",
  ];

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
    );

    if (result != null && result.files.single.path != null) {
      widget.onImagePicked(File(result.files.single.path!));
    }
  }

  void _internalSubmit() {
    if (_formKey.currentState!.validate() &&
        widget.selectedImage != null &&
        widget.selectedCategory != null) {
      widget.onSubmit();
    } else {
      ShowAwesomeDialog.error(context, "تحقق من البيانات وأرفق صورة!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = context
        .watch<ThemeCubit>()
        .state;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: widget.nameController,
            hint: "Product Name",
            prefixIcon: Icons.text_fields,
            validator: (value) =>
            value == null || value.isEmpty ? 'أدخل اسم المنتج' : null,
          ),
          Gap(h: 16),
          DropdownButtonFormField<String>(
            value: widget.selectedCategory,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.category),
              filled: true,
              fillColor: AppColors.primaryColor(isDarkMode),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            hint: Text(
              " Choose Category",
              style: TextStyle(
                color: AppColors.secondaryTextColor(isDarkMode),

              ),
            ),
            dropdownColor: AppColors.primaryColor(isDarkMode),
            items: categories.map((cat) {
              return DropdownMenuItem<String>(
                value: cat,
                child: Text(
                  cat,
                  style: TextStyle(
                    color: AppColors.primaryTextColor(isDarkMode),
                  ),
                ),
              )
              ;
            }).toList(),
            onChanged: widget.onCategoryChanged,
            validator: (value) => value == null ? 'Choose Category' : null,
          ),
          Gap(h: 16),
          CustomTextField(
            controller: widget.priceController,
            hint: "Product Price",
            keyboardType: TextInputType.number,
            prefixIcon: Icons.attach_money,
            validator: (value) =>
            value == null || value.isEmpty ? 'أدخل السعر' : null,
          ),
          Gap(h: 16),
          CustomTextField(
            controller: widget.descriptionController,
            hint: "Product Description",
            prefixIcon: Icons.description,
            minLines: 4,
            maxLines: 6,
            validator: (value) =>
            value == null || value.isEmpty ? 'أدخل وصف المنتج' : null,
          ),
          Gap(h: 24),
          ImageUploader(
              onImageSelected:widget.onImagePicked,
              selectedImage: widget.selectedImage
          ),
          Gap(h: 32),

          CustomButton(
            title: "Add Product",
            onPressed: _internalSubmit,
            isLoading: widget.isLoading,
          ),


          Gap(h: 24),
        ],
      ),
    );
  }
}