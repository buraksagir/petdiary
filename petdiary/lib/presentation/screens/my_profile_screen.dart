// ignore_for_file: use_build_context_synchronously
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petdiary/presentation/widgets/snackbar.dart';
import 'package:petdiary/presentation/widgets/text_field.dart';
import '../../cubit/pet/pet_cubit.dart';
import '../../cubit/pet/pet_cubit_state.dart';
import '../../cubit/post/post_cubit.dart';
import '../../cubit/post/post_cubit_state.dart';
import '../../cubit/user/user_cubit.dart';
import '../../cubit/user/user_cubit_state.dart';
import '../../data/models/post_model.dart';
import '../../data/models/user_model.dart';
import '../../generated/locale_keys.g.dart';
import '../../services/shared_preferences.dart';
import '../themes/app_theme.dart';
import '../widgets/divider.dart';
import 'auth/sign_in_screen.dart';
import 'edit_profile_screen.dart';

class MyProfileScreen extends StatefulWidget {
  final String? contextUser;
  const MyProfileScreen({super.key, required this.contextUser});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  SharedPreferencesUtils sharedPreferencesUtils = SharedPreferencesUtils();
  Pet? selectedPet;

  @override
  void initState() {
    super.initState();
    context.read<MyUserCubit>().getMyUserById(widget.contextUser ?? "");
    context.read<MyPostCubit>().getOwnPost(widget.contextUser ?? "");
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    context.read<MyUserCubit>().getMyUserById(widget.contextUser ?? "");
    context.read<MyPostCubit>().getOwnPost(widget.contextUser ?? "");
  }

  int selectedPhotoIndex = -1;
  String url =
      "https://www.indyturk.com/sites/default/files/styles/1368x911/public/article/main_image/2019/07/01/124116-151213975.jpg?itok=mM63-S_7";
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: BlocConsumer<MyUserCubit, MyUserState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: SizedBox(
                width: 125,
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            );
          } else if (state.isLoaded) {
            List<User>? users = state.userListModel;
            User? user = users?.first;
            String? followerCount = user?.followers?.length.toString();
            String? followingCount = user?.following?.length.toString();
            String? name = user?.name;
            String? bio = user?.bio ?? "";
            String? username = user?.userName;
            List<Pet>? pets = user?.pets;

            return RefreshIndicator(
              onRefresh: _refresh,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                  body: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    Image.asset(
                                      'assets/images/asdasd.jpg',
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                spreadRadius: 7,
                                                blurRadius: 30,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  name!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: AppTheme
                                                              .lightTheme
                                                              .textTheme
                                                              .displayLarge!
                                                              .fontSize! +
                                                          2,
                                                      fontFamily: AppTheme
                                                          .darkTheme
                                                          .textTheme
                                                          .bodySmall!
                                                          .fontFamily),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Text(
                                                  "@$username",
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: AppTheme
                                                          .lightTheme
                                                          .textTheme
                                                          .bodySmall!
                                                          .fontSize,
                                                      fontFamily: AppTheme
                                                          .darkTheme
                                                          .textTheme
                                                          .bodyLarge!
                                                          .fontFamily),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8, bottom: 8),
                                          child: Hero(
                                            tag: 'editProfile',
                                            child: IconButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            AppTheme
                                                                .lightTheme
                                                                .colorScheme
                                                                .primary)),
                                                icon: Icon(Icons.edit,
                                                    color: AppTheme.lightTheme
                                                        .colorScheme.secondary),
                                                iconSize: 28,
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: ((context) =>
                                                          BlocProvider<
                                                              MyUserCubit>(
                                                            create: (context) =>
                                                                MyUserCubit(),
                                                            child:
                                                                EditProfileScreen(
                                                              contextUser:
                                                                  user ??
                                                                      User(),
                                                            ),
                                                          )),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 6, top: 6),
                                  child: PopupMenuButton(
                                    surfaceTintColor: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'theme',
                                        child: Text(LocaleKeys.changeTheme.tr(),
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      ),
                                      PopupMenuItem(
                                        value: 'language',
                                        child: Text(
                                          LocaleKeys.changeLanguage.tr(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'logout',
                                        child: Text(
                                          LocaleKeys.logout.tr(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      )
                                    ],
                                    onSelected: (value) {
                                      if (value == 'logout') {
                                        logout(context);
                                      } else if (value == 'theme') {
                                        //! Theme selection
                                      } else if (value == 'language') {
                                        Locale newLocale =
                                            context.locale.languageCode == 'tr'
                                                ? const Locale('en', 'US')
                                                : const Locale('tr', 'TR');
                                        context.setLocale(newLocale);
                                      }
                                    },
                                    icon: Icon(Icons.settings,
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary),
                                  ),
                                ),
                              ],
                            ),
                            Card(
                              margin: const EdgeInsets.all(0),
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              child: Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: _buildUserColumn("$followerCount",
                                        LocaleKeys.follower.tr()),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: _buildUserColumn("$followingCount",
                                        LocaleKeys.following.tr()),
                                  ),
                                  MyDivider().getDivider(),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      bio,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall,
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  MyDivider().getDivider(),
                                  buildPetSection(pets),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: SizedBox(
                width: 125,
                child: Center(
                  child: Text(LocaleKeys.refresh.tr()),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Container buildPetBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      height: 40,
      width: MediaQuery.of(context).size.width - 110,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      alignment: Alignment.center,
      child: Text(
        selectedPet?.petName ?? LocaleKeys.selectPet.tr(),
        style: TextStyle(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget buildPetSection(List<Pet>? pets) {
    //! PET SECTION
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          if (pets != null && pets.isNotEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  Pet pet = pets[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPet = pet;
                      });
                    },
                    onLongPress: () {
                      _showPetEditDialog(selectedPet!.id.toString());
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withAlpha(100),
                              blurRadius: 1,
                            ),
                          ],
                          image: const DecorationImage(
                              image: AssetImage('assets/images/app_logo.png'),
                              scale: 4)),
                    ),
                  );
                },
              ),
            ),
          MyDivider().getDivider(),
          Row(
            children: [
              buildPetBar(context),
              _buildPetCreateButton("", ""),
            ],
          ),
          MyDivider().getDivider(),
          _buildPetPosts(),
        ],
      ),
    );
  }

  Widget _buildPetPosts() {
    return BlocBuilder<MyPostCubit, MyPostState>(
      builder: (context, postState) {
        if (postState.isLoaded) {
          List<Post>? userPosts = postState.userPostModel;
          if (userPosts != null && userPosts.isNotEmpty) {
            List<Post> petPosts = userPosts
                .where((post) => post.petIds?.first == selectedPet?.id)
                .toList();
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: petPosts.isNotEmpty
                  ? Container(
                      key: ValueKey<int>(petPosts.length),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 200,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemCount: petPosts.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPhotoIndex = index;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    blurRadius: 1,
                                  ),
                                ],
                                image: const DecorationImage(
                                  image: NetworkImage(
                                      "https://images.pexels.com/photos/325407/pexels-photo-325407.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      key: const ValueKey<int>(0),
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      height: 150,
                      child: Center(
                        child: Text(
                          LocaleKeys.youHaveNoPost.tr(),
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ),
                    ),
            );
          } else {
            return Container(
              color: AppTheme.lightTheme.colorScheme.secondary,
              height: 150,
              child: Center(
                child: Text(
                  LocaleKeys.youHaveNoPost.tr(),
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ),
            );
          }
        } else if (postState.isLoading) {
          return Center(
            child: SizedBox(
              width: 125,
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          );
        } else {
          return Container(
            color: AppTheme.lightTheme.colorScheme.secondary,
            height: 150,
            child: Center(
              child: Text(
                LocaleKeys.youHaveNoPost.tr(),
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ),
          );
        }
      },
    );
  }

  void logout(BuildContext context) {
    sharedPreferencesUtils.deleteToken();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false,
    );
  }

  Widget _buildUserColumn(String text, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildPetCreateButton(String userId, String petName) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(
          Icons.add_box_rounded,
        ),
        color: AppTheme.lightTheme.colorScheme.secondary,
        onPressed: () {
          _showMyDialog();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
                AppTheme.lightTheme.colorScheme.primary)),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    TextEditingController petNameRegController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => PetCubit(),
          child: AlertDialog(
            title: Text(LocaleKeys.createPet.tr()),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  FieldWidget(
                      regController: petNameRegController,
                      label: LocaleKeys.createPetName.tr(),
                      keyboardType: TextInputType.text,
                      isPassword: false),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('İptal'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              BlocBuilder<PetCubit, PetState>(
                builder: (context, state) {
                  return TextButton(
                    child: const Text('Yarat'),
                    onPressed: () {
                      context.read<PetCubit>().createPet(
                          widget.contextUser!, petNameRegController.text);
                      SnackBar petCreateSnackBar =
                          MySnackBar().getSnackBar(LocaleKeys.petCreated.tr());
                      ScaffoldMessenger.of(context)
                          .showSnackBar(petCreateSnackBar);
                      Navigator.of(context).pop();
                      _refresh();
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showPetEditDialog(String petId) async {
    TextEditingController petNameRegController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => PetCubit(),
          child: AlertDialog(
            title: Text(LocaleKeys.edit.tr()),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  FieldWidget(
                      regController: petNameRegController,
                      label: LocaleKeys.createPetName.tr(),
                      keyboardType: TextInputType.text,
                      isPassword: false),
                ],
              ),
            ),
            actions: <Widget>[
              BlocBuilder<PetCubit, PetState>(
                builder: (context, state) {
                  return TextButton(
                    child: Text(LocaleKeys.delete.tr()),
                    onPressed: () {
                      _areYouSureDialog(petId);
                    },
                  );
                },
              ),
              TextButton(
                child: Text(LocaleKeys.cancel.tr()),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              BlocBuilder<PetCubit, PetState>(
                builder: (context, state) {
                  return TextButton(
                    child: Text(LocaleKeys.save.tr()),
                    onPressed: () {
                      if (petNameRegController.text.isNotEmpty) {
                        context.read<PetCubit>().changePetName(petId,
                            widget.contextUser!, petNameRegController.text);
                        Navigator.of(context).pop();
                      } else {
                        SnackBar errorSnackbar =
                            MySnackBar().getSnackBar("denem");

                        ScaffoldMessenger.of(context)
                            .showSnackBar(errorSnackbar);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _areYouSureDialog(String petId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => PetCubit(),
          child: AlertDialog(
            title: Text(LocaleKeys.edit.tr()),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text(LocaleKeys.areYouSure.tr())],
              ),
            ),
            actions: <Widget>[
              BlocBuilder<PetCubit, PetState>(
                builder: (context, state) {
                  return TextButton(
                    child: Text(LocaleKeys.no.tr()),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
              BlocBuilder<PetCubit, PetState>(
                builder: (context, state) {
                  return TextButton(
                    child: Text(LocaleKeys.yes.tr()),
                    onPressed: () {
                      context.read<PetCubit>().deletePet(petId);
                      _refresh();
                      selectedPet = null;
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
