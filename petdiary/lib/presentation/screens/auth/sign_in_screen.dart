import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petapp/presentation/widgets/snackbar.dart';

import '../../../cubit/auth/login_cubit.dart';
import '../../../cubit/auth/login_cubit_state.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../services/shared_preferences.dart';
import '../../themes/app_theme.dart';
import '../root_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  SharedPreferencesUtils sharedPreferencesUtils = SharedPreferencesUtils();
  TextEditingController userNameRegController = TextEditingController();
  TextEditingController passwordRegController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    LocaleKeys.hello.tr(),
                    style: AppTheme.lightTheme.textTheme.displayLarge,
                  ),
                  Text(LocaleKeys.toContinue.tr(),
                      style: AppTheme.lightTheme.textTheme.bodyMedium),
                  const Spacer(flex: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textField(userNameRegController, LocaleKeys.userName.tr(),
                          TextInputType.name, false),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textField(passwordRegController, LocaleKeys.password.tr(),
                          TextInputType.name, true),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 40),
                        child: BlocConsumer<LoginCubit, LoginState>(
                          listener: (context, state) {
                            final tokenModel = state.tokenModel;
                            if (tokenModel != null) {
                              sharedPreferencesUtils.saveToken(
                                  tokenModel.accessToken!,
                                  tokenModel.userId.toString());

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RootScreen(
                                      contextUserId:
                                          tokenModel.userId.toString()),
                                ),
                              );
                            } else if (state.errorMessage!.isNotEmpty &&
                                state.isLoading == false) {
                              SnackBar loginFailedSnackbar = MySnackBar()
                                  .getSnackBar(LocaleKeys.loginFailed.tr());
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(loginFailedSnackbar);
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: state.isLoading
                                    ? MaterialStatePropertyAll(
                                        Colors.grey.withOpacity(0.5))
                                    : MaterialStatePropertyAll(
                                        AppTheme.lightTheme.colorScheme.primary,
                                      ),
                              ),
                              onPressed: () {
                                login(
                                  context,
                                  userNameRegController,
                                  passwordRegController,
                                );
                              },
                              child: Text(
                                LocaleKeys.login.tr(),
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            LocaleKeys.forgotPassword.tr(),
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: Text(
                          LocaleKeys.areYouNew.tr(),
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 35,
                    child: const Image(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/app_logo.png"),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textField(TextEditingController regController, String label,
      TextInputType keyboardType, bool isPassword) {
    return SizedBox(
      width: 290,
      height: 65,
      child: TextFormField(
        style: AppTheme.lightTheme.textTheme.bodyMedium,
        autovalidateMode: AutovalidateMode.always,
        controller: regController,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            fillColor: AppTheme.lightTheme.colorScheme.background,
            alignLabelWithHint: true,
            filled: true,
            labelText: label,
            labelStyle: AppTheme.lightTheme.textTheme.bodySmall),
      ),
    );
  }

  void login(
    BuildContext context,
    TextEditingController userNameRegController,
    TextEditingController passwordRegController,
  ) async {
    await context.read<LoginCubit>().login(
          userNameRegController.text,
          passwordRegController.text,
        );
  }
}
