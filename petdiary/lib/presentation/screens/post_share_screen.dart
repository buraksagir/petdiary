import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petapp/cubit/user/user_cubit.dart';
import '../../cubit/post/post_cubit.dart';
import '../../cubit/post/post_cubit_state.dart';
import '../../cubit/user/user_cubit_state.dart';
import '../../generated/locale_keys.g.dart';
import '../themes/app_theme.dart';
import '../validators/textfield_validators.dart';
import '../widgets/snackbar.dart';
import '../widgets/text_field.dart';

class PostShareScreen extends StatefulWidget {
  final String? contextUser;
  final List<String> petTags;

  const PostShareScreen({
    super.key,
    required this.contextUser,
    required this.petTags,
  });

  @override
  State<PostShareScreen> createState() => _PostShareScreenState();
}

class _PostShareScreenState extends State<PostShareScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  XFile? _image;
  File? file;
  TextFieldValidators validator = TextFieldValidators();
  int? selectedPetId;
  List<Map<String, Object>>? petsData = [];

  @override
  void initState() {
    super.initState();
    context.read<MyUserCubit>().getMyUserById(widget.contextUser!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.lightTheme.colorScheme.background,
        actions: [
          BlocBuilder<MyUserCubit, MyUserState>(
            builder: (context, state) {
              if (state.isLoaded &&
                  state.userListModel!.first.pets!.isNotEmpty) {
                var pets = state.userListModel?.first.pets;

                petsData = pets?.map((pet) {
                  return {
                    'id': pet.id!,
                    'name': pet.petName!,
                  };
                }).toList();

                var dropdownItems = petsData?.map((pet) {
                  return DropdownMenuItem<int>(
                    value: pet['id'] as int,
                    child: Text(pet['name'] as String),
                  );
                }).toList();

                return DropdownButton<int>(
                  hint: const Text("Select Pet"),
                  value: selectedPetId,
                  items: dropdownItems,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedPetId = newValue;
                    });
                  },
                );
              } else if (state.isLoading) {
                return const CircularProgressIndicator();
              } else {
                return Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  alignment: Alignment.center,
                  child: Text(
                    "  ${LocaleKeys.createPetToSharePost.tr()}  ",
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                );
              }
            },
          ),
          file != null && _image != null
              ? BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    log(_image!.path);
                    return ElevatedButton(
                      onPressed: selectedPetId != null
                          ? () {
                              sharePost(context);
                            }
                          : null,
                      child: const Text("Paylaş"),
                    );
                  },
                )
              : const SizedBox(),
        ],
      ),
      body: Center(
        child: _image != null && file != null
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      child: Image.file(
                        File(_image!.path),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FieldWidget(
                      validator: validator.validatePostDescription,
                      regController: _textEditingController,
                      label: LocaleKeys.description.tr(),
                      keyboardType: TextInputType.text,
                      isPassword: false,
                    ),
                  ],
                ),
              )
            : Text(LocaleKeys.photoIsNotPicked.tr()),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _getImageFromGallery,
            tooltip: LocaleKeys.pickPhoto.tr(),
            child: const Icon(Icons.perm_media_outlined),
          ),
          const SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            onPressed: _getImageFromCamera,
            tooltip: LocaleKeys.pickPhoto.tr(),
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }

  void sharePost(BuildContext context) {
    SnackBar mySnackBar = MySnackBar().getSnackBar(LocaleKeys.postShared.tr());

    context.read<MyPostCubit>().createPost(
          file!,
          _textEditingController.text,
          widget.contextUser!,
          selectedPetId.toString(),
        );
    _refresh();
    ScaffoldMessenger.of(context).showSnackBar(mySnackBar);
  }

  Future<void> _getImageFromGallery() async {
    final imagePickerGallery = ImagePicker();
    final XFile? image =
        await imagePickerGallery.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = image;
        file = File(image.path);
      });
    } else {
      Center(
        child: SizedBox(
          width: 125,
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
      );
    }
  }

  Future<void> _getImageFromCamera() async {
    final imagePickerCamera = ImagePicker();
    final XFile? image =
        await imagePickerCamera.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = image;
        file = File(image.path);
      });
    } else {
      Center(
        child: SizedBox(
          width: 125,
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
      );
    }
  }

  void _refresh() {
    //* Refresh method
    setState(() {
      _image = null;
      file = null;
      selectedPetId = null;
    });
  }
}
