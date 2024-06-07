import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petdiary/cubit/auth/register_cubit.dart';
import 'package:petdiary/cubit/auth/register_cubit_state.dart';
import 'package:petdiary/presentation/themes/app_theme.dart';
import 'package:petdiary/presentation/validators/textfield_validators.dart';
import 'package:petdiary/presentation/widgets/snackbar.dart';
import 'package:petdiary/presentation/widgets/text_field.dart';

import '../../../generated/locale_keys.g.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<SignUpPage> {
  int currentStep = 0;

  TextEditingController usernameRegController = TextEditingController();
  TextEditingController mailRegController = TextEditingController();
  TextEditingController passwordRegController = TextEditingController();
  TextEditingController phoneRegController = TextEditingController();
  TextEditingController nameRegController = TextEditingController();
  TextEditingController surnameRegController = TextEditingController();

  TextFieldValidators validator = TextFieldValidators();

  SnackBar mySnackBar =
      MySnackBar().getSnackBar(LocaleKeys.accountCreated.tr());

  @override
  Widget build(BuildContext mainContext) {
    return BlocProvider<RegisterCubit>(
      create: (context) => RegisterCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            LocaleKeys.register.tr(),
            style: AppTheme.lightTheme.textTheme.displayMedium,
          ),
          forceMaterialTransparency: true,
        ),
        body: Stepper(
          controlsBuilder: (context, details) {
            return Row(children: [
              const SizedBox(width: 24.0),
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (blocContext, state) {
                  return ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          AppTheme.lightTheme.colorScheme.primary),
                    ),
                    onPressed: () {
                      bool isValid = true;
                      if (currentStep == 0) {
                        setState(() {
                          validator.usernameError = validator
                              .validateUsername(usernameRegController.text);
                          validator.passwordError = validator
                              .validatePassword(passwordRegController.text);
                          isValid = validator.usernameError == null &&
                              validator.passwordError == null;
                        });
                      } else if (currentStep == 1) {
                        setState(() {
                          validator.nameError =
                              validator.validateName(nameRegController.text);
                          validator.surnameError = validator
                              .validateSurname(surnameRegController.text);
                          validator.mailError =
                              validator.validateMail(mailRegController.text);
                          validator.phoneError =
                              validator.validatePhone(phoneRegController.text);
                          isValid = validator.nameError == null &&
                              validator.surnameError == null &&
                              validator.mailError == null &&
                              validator.phoneError == null;
                        });
                      }
                      if (isValid) {
                        if (currentStep < 1) {
                          setState(() {
                            currentStep += 1;
                          });
                        } else if (currentStep == 1) {
                          register(blocContext);
                          if (state.isLoading) {
                            const CircularProgressIndicator();
                          } else if (state.isLoaded) {
                            ScaffoldMessenger.of(mainContext)
                                .showSnackBar(mySnackBar);
                          }
                        }
                      }
                    },
                    child: Text(
                        currentStep == 1
                            ? LocaleKeys.register.tr()
                            : LocaleKeys.next.tr(),
                        style: AppTheme.lightTheme.textTheme.bodyMedium),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        AppTheme.lightTheme.colorScheme.primary)),
                onPressed: () {
                  if (currentStep > 0) {
                    setState(() {
                      currentStep -= 1;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Text(LocaleKeys.back.tr(),
                    style: AppTheme.lightTheme.textTheme.bodyMedium),
              )
            ]);
          },
          connectorColor:
              MaterialStatePropertyAll(AppTheme.lightTheme.colorScheme.primary),
          currentStep: currentStep,
          steps: [
            Step(
              title: Text(
                LocaleKeys.userInfo.tr(),
                style: AppTheme.lightTheme.textTheme.displaySmall,
              ),
              content: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  FieldWidget(
                    validator: validator.validateUsername,
                    regController: usernameRegController,
                    label: LocaleKeys.userName.tr(),
                    keyboardType: TextInputType.name,
                    isPassword: false,
                    errorMessage: validator.usernameError,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FieldWidget(
                    validator: validator.validatePassword,
                    regController: passwordRegController,
                    label: LocaleKeys.password.tr(),
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    errorMessage: validator.passwordError,
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
              isActive: currentStep == 0,
            ),
            Step(
              title: Text(
                LocaleKeys.contactInfo.tr(),
                style: AppTheme.lightTheme.textTheme.displaySmall,
              ),
              content: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  FieldWidget(
                    validator: validator.validateName,
                    label: LocaleKeys.name.tr(),
                    regController: nameRegController,
                    keyboardType: TextInputType.name,
                    isPassword: false,
                    errorMessage: validator.nameError,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FieldWidget(
                    validator: validator.validateSurname,
                    label: LocaleKeys.surname.tr(),
                    regController: surnameRegController,
                    keyboardType: TextInputType.name,
                    isPassword: false,
                    errorMessage: validator.surnameError,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FieldWidget(
                    validator: validator.validateMail,
                    label: LocaleKeys.mail.tr(),
                    regController: mailRegController,
                    keyboardType: TextInputType.emailAddress,
                    isPassword: false,
                    errorMessage: validator.mailError,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FieldWidget(
                    validator: validator.validatePhone,
                    label: LocaleKeys.phone.tr(),
                    regController: phoneRegController,
                    keyboardType: TextInputType.phone,
                    isPassword: false,
                    errorMessage: validator.phoneError,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              isActive: currentStep == 1,
            ),
          ],
        ),
      ),
    );
  }

  void register(BuildContext blocContext) async {
    await blocContext.read<RegisterCubit>().register(
        usernameRegController.text,
        passwordRegController.text,
        nameRegController.text,
        surnameRegController.text,
        mailRegController.text,
        phoneRegController.text);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(blocContext).showSnackBar(mySnackBar);
    Navigator.of(context).pop();
  }
}
