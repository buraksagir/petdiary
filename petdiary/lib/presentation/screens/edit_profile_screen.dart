import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petapp/cubit/auth/login_cubit.dart';
import 'package:petapp/cubit/auth/login_cubit_state.dart';
import 'package:petapp/presentation/validators/textfield_validators.dart';
import 'package:petapp/presentation/widgets/snackbar.dart';
import '../../cubit/user/user_cubit.dart';
import '../../cubit/user/user_cubit_state.dart';
import '../../data/models/user_model.dart';
import '../../generated/locale_keys.g.dart';
import '../themes/app_theme.dart';
import '../widgets/text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.contextUser});

  final User? contextUser;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController userNameRegController = TextEditingController();
  TextEditingController nameRegController = TextEditingController();
  TextEditingController surnameRegController = TextEditingController();
  TextEditingController bioRegController = TextEditingController();
  TextEditingController phoneRegController = TextEditingController();
  TextEditingController mailRegController = TextEditingController();
  TextEditingController passwordRegController = TextEditingController();
  TextFieldValidators validator = TextFieldValidators();

  @override
  void initState() {
    super.initState();
    userNameRegController.text = widget.contextUser?.userName ?? "";
    nameRegController.text = widget.contextUser?.name ?? "";
    surnameRegController.text = widget.contextUser?.surname ?? "";
    bioRegController.text = widget.contextUser?.bio ?? "";
    phoneRegController.text = widget.contextUser?.phone ?? "";
    mailRegController.text = widget.contextUser?.mail ?? "";
    profileLock = widget.contextUser!.profileLock;

    passwordRegController.addListener(() {});
  }

  XFile? _pickedFile;
  CroppedFile? _croppedFile;

  bool? profileLock;

  @override
  Widget build(BuildContext context) {
    User? user = widget.contextUser;

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        body: Hero(
          tag: 'editProfileEdit',
          child: Scaffold(
            backgroundColor: AppTheme.lightTheme.colorScheme.background,
            appBar: AppBar(
              title: Text(
                style: AppTheme.lightTheme.textTheme.bodyLarge,
                LocaleKeys.editProfile.tr(),
              ),
              backgroundColor: AppTheme.lightTheme.colorScheme.background,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 10, right: 10),
                                  child: FieldWidget(
                                    isPassword: false,
                                    keyboardType: TextInputType.text,
                                    regController: nameRegController,
                                    label: LocaleKeys.name.tr(),
                                    validator: validator.validateName,
                                    errorMessage: validator.nameError,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 10, right: 10),
                                  child: FieldWidget(
                                    isPassword: false,
                                    keyboardType: TextInputType.text,
                                    regController: surnameRegController,
                                    label: LocaleKeys.surname.tr(),
                                    validator: validator.validateSurname,
                                    errorMessage: validator.surnameError,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.2,
                            height: 160,
                            child: GestureDetector(
                              onTap: () {
                                _uploadImage();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: user?.photo == null
                                      ? const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/app_logo.png'),
                                          fit: BoxFit.cover,
                                        )
                                      : const DecorationImage(
                                          image: AssetImage(
                                              "assets/images/asdasd.jpg"),
                                          fit: BoxFit.cover),
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withAlpha(40),
                                ),
                                child: user?.photo == null
                                    ? Center(
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: 50,
                                          color: AppTheme
                                              .lightTheme.colorScheme.primary,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 10, right: 10),
                              child: FieldWidget(
                                isPassword: false,
                                keyboardType: TextInputType.text,
                                regController: userNameRegController,
                                label: LocaleKeys.userName.tr(),
                                validator: validator.validateUsername,
                                errorMessage: validator.usernameError,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 10, right: 10),
                              child: FieldWidget(
                                isPassword: false,
                                keyboardType: TextInputType.text,
                                regController: phoneRegController,
                                label: LocaleKeys.phone.tr(),
                                validator: validator.validatePhone,
                                errorMessage: validator.phoneError,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, right: 10),
                          child: FieldWidget(
                            isPassword: false,
                            keyboardType: TextInputType.text,
                            regController: bioRegController,
                            label: LocaleKeys.bio.tr(),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: FieldWidget(
                          isPassword: false,
                          keyboardType: TextInputType.text,
                          regController: mailRegController,
                          label: LocaleKeys.mail.tr(),
                          validator: validator.validateMail,
                          errorMessage: validator.mailError,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, right: 10),
                          child: FieldWidget(
                            isPassword: false,
                            keyboardType: TextInputType.text,
                            regController: passwordRegController,
                            label: LocaleKeys.enterPassword.tr(),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            //* Profile Lock switch
                            padding: const EdgeInsets.only(
                                left: 10, top: 10, right: 10),
                            child: BlocBuilder<MyUserCubit, MyUserState>(
                              builder: (context, state) {
                                return Switch(
                                  value: user!.profileLock ?? false,
                                  onChanged: (value) {
                                    value
                                        ? {
                                            user.profileLock = true,
                                            context
                                                .read<MyUserCubit>()
                                                .changeProfileLock(
                                                    widget.contextUser!.id
                                                        .toString(),
                                                    true)
                                          }
                                        : {
                                            user.profileLock = false,
                                            context
                                                .read<MyUserCubit>()
                                                .changeProfileLock(
                                                    widget.contextUser!.id
                                                        .toString(),
                                                    false)
                                          };
                                  },
                                );
                              },
                            ),
                          ),
                          Padding(
                            //* Profile Lock text
                            padding: const EdgeInsets.only(right: 85, top: 10),
                            child: Text(LocaleKeys.profileLock.tr()),
                          ),
                          Padding(
                            //* Save button
                            padding: const EdgeInsets.only(
                                right: 18, top: 12, bottom: 12),
                            child: BlocListener<LoginCubit, LoginState>(
                              listener: (context, state) {
                                if (state.credidentalLoaded &&
                                    state.isEmpty == false) {
                                  updateUserInfo(context);
                                  context.read<LoginCubit>().reset;
                                } else if (state.isEmpty == true) {
                                  SnackBar wrongPasswordSnackBar = MySnackBar()
                                      .getSnackBar(state.errorMessage);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(wrongPasswordSnackBar);
                                }
                              },
                              child: BlocBuilder<LoginCubit, LoginState>(
                                builder: (context, state) {
                                  bool isActive =
                                      passwordRegController.text.length > 3;
                                  return ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: isActive
                                          ? MaterialStatePropertyAll(AppTheme
                                              .lightTheme.colorScheme.primary)
                                          : MaterialStatePropertyAll(AppTheme
                                              .lightTheme
                                              .colorScheme
                                              .background),
                                    ),
                                    onPressed: isActive
                                        ? () {
                                            save(context);
                                          }
                                        : null,
                                    child: Text(
                                      LocaleKeys.save.tr(),
                                      style: TextStyle(
                                        color: isActive
                                            ? AppTheme.lightTheme.colorScheme
                                                .secondary
                                            : AppTheme
                                                .lightTheme.colorScheme.primary,
                                      ),
                                    ),
                                  );
                                },
                              ),
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
        ),
      ),
    );
  }

  Future<void> save(BuildContext context) async {
    await context
        .read<LoginCubit>()
        .getToken(widget.contextUser!.userName!, passwordRegController.text);
  }

  void updateUserInfo(BuildContext context) {
    if (userNameRegController.text.length >= 3 &&
        mailRegController.text.length >= 3 &&
        phoneRegController.text.length > 6 &&
        nameRegController.text.length >= 2 &&
        surnameRegController.text.length >= 2 &&
        _croppedFile != null) {
      context.read<MyUserCubit>().editUserInfo(
          widget.contextUser!.id.toString(),
          userNameRegController.text,
          mailRegController.text,
          passwordRegController.text,
          phoneRegController.text,
          bioRegController.text,
          nameRegController.text,
          surnameRegController.text,
          File(_croppedFile!.path));
      SnackBar snackBarSuccess =
          MySnackBar().getSnackBar(LocaleKeys.profileEditSuccess.tr());

      ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
    } else if (userNameRegController.text.length >= 3 &&
        mailRegController.text.length >= 3 &&
        phoneRegController.text.length > 6 &&
        nameRegController.text.length >= 2 &&
        surnameRegController.text.length >= 2 &&
        _croppedFile == null) {
      context.read<MyUserCubit>().editUserInfo(
            widget.contextUser!.id.toString(),
            userNameRegController.text,
            mailRegController.text,
            passwordRegController.text,
            phoneRegController.text,
            bioRegController.text,
            nameRegController.text,
            surnameRegController.text,
          );
      SnackBar snackBarSuccess =
          MySnackBar().getSnackBar(LocaleKeys.profileEditSuccess.tr());

      ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
    } else {
      SnackBar snackBarFail =
          MySnackBar().getSnackBar(LocaleKeys.profileEditFail.tr());
      ScaffoldMessenger.of(context).showSnackBar(snackBarFail);
    }
  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: AppTheme.lightTheme.colorScheme.primary,
              toolbarWidgetColor: AppTheme.lightTheme.colorScheme.secondary,
              cropStyle: CropStyle.circle,
              lockAspectRatio: true,
              backgroundColor: AppTheme.lightTheme.colorScheme.background),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        _cropImage();
      });
    }
  }

  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
