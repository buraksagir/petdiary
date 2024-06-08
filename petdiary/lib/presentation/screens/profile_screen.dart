// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/follow/follow_cubit.dart';
import '../../cubit/follow/follow_cubit_state.dart';
import '../../cubit/post/post_cubit.dart';
import '../../cubit/post/post_cubit_state.dart';
import '../../cubit/user/user_cubit.dart';
import '../../cubit/user/user_cubit_state.dart';
import '../../data/models/post_model.dart';
import '../../data/models/user_model.dart';
import '../../generated/locale_keys.g.dart';
import '../../services/shared_preferences.dart';
import '../themes/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  final String? selectedUserId;
  final String? contextUser;

  const ProfileScreen(
      {super.key, required this.selectedUserId, required this.contextUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  SharedPreferencesUtils sharedPreferencesUtils = SharedPreferencesUtils();
  late final String? selectedUser;
  Pet? selectedPet;

  bool? isFollowing;
  bool? profileLock;
  bool? isRequestSent;
  String followBtnText = "";
  String? followId = "";
  String? requestId = "";
  int? followerCount;
  int? followingCount;

  late final FollowCubit _followCubit;
  int selectedPhotoIndex = -1;

  @override
  void initState() {
    super.initState();
    selectedUser = widget.selectedUserId;
    _followCubit = context.read<FollowCubit>();
    context.read<SingleUserCubit>().getUserById(selectedUser ?? "");
    context.read<PostCubit>().getPostByUserId(selectedUser ?? "");
    _followCubit.getUsersFollowRequests(selectedUser ?? "");
    _followCubit.getFollowingOfUser(widget.contextUser!);

    _followCubit.stream.listen(
      (state) => setState(() {
        if (state.isLoaded) {
          isFollowing = state.follows?.any(
            (element) {
              return element.followedUserId.toString() == widget.selectedUserId;
            },
          );

          if (isFollowing!) {
            followId = state.follows
                    ?.firstWhere((element) =>
                        element.followedUserId.toString() ==
                        widget.selectedUserId)
                    .id
                    .toString() ??
                "";
          }

          isRequestSent = state.followRequests?.any((element) {
            return (element.userId.toString() == widget.contextUser);
          });
          if (isRequestSent == true) {
            textBtn();

            textBtn();
          } else {
            textBtn();
          }
        }
      }),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    context.read<SingleUserCubit>().getUserById(selectedUser ?? "");
    context.read<PostCubit>().getPostByUserId(selectedUser ?? "");
    _followCubit.getUsersFollowRequests(selectedUser ?? "");
    _followCubit.getFollowingOfUser(widget.contextUser!);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<SingleUserCubit, SingleUserState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            body: Hero(
              tag: 'go-to-profile',
              child: Center(
                child: SizedBox(
                  width: 125,
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (state.isLoaded) {
          if (state.userListModel != null) {
            List<User>? users = state.userListModel;
            User? user = users?.first;
            profileLock = user?.profileLock;
            followerCount = user?.followers?.length;
            followingCount = user?.following?.length;
            String? name = user?.name;
            String? bio = user?.bio ?? "";
            String? username = user?.userName;
            List<Pet>? pets = user?.pets;

            return RefreshIndicator(
              onRefresh: _refresh,
              child: Scaffold(
                body: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  Image.network(
                                    user!.photo!,
                                    fit: BoxFit.cover,
                                    height:
                                        MediaQuery.of(context).size.height / 2,
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
                                              color:
                                                  Colors.black.withOpacity(0.3),
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
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 28),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                "@$username",
                                                style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 14),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: BlocBuilder<FollowCubit,
                                            FollowState>(
                                          builder: (context, state) {
                                            return ElevatedButton(
                                              style: const ButtonStyle(
                                                  shadowColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.white38),
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.transparent)),
                                              onPressed: () {
                                                if (isFollowing == true) {
                                                  unfollow(
                                                      widget.contextUser!,
                                                      widget.selectedUserId ??
                                                          "");
                                                  textBtn();
                                                } else if (isFollowing ==
                                                        false &&
                                                    isRequestSent == false) {
                                                  follow(widget.contextUser!,
                                                      selectedUser!);

                                                  textBtn();
                                                } else if (isFollowing ==
                                                        false &&
                                                    isRequestSent == true) {
                                                  deleteRequest(
                                                      widget.contextUser!,
                                                      widget.selectedUserId!);
                                                  textBtn();
                                                }
                                              },
                                              child: Text(
                                                // ignore: unnecessary_string_interpolations
                                                "$followBtnText",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new,
                                    ),
                                    color: AppTheme
                                        .lightTheme.colorScheme.primary),
                              ),
                            ],
                          ),
                          Card(
                            color: AppTheme.lightTheme.colorScheme.background,
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
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    bio,
                                    style:
                                        AppTheme.lightTheme.textTheme.bodySmall,
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                _buildDivider(),
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
            );
          } else {
            return const Center(
              child: Text("404"),
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: SizedBox(
                width: 125,
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildPetBar(BuildContext context) {
    if (profileLock == false || isFollowing == true) {
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
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        alignment: Alignment.center,
        child: Text(
          selectedPet?.petName ?? "Gönderilerini görmek istediğin peti seç",
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      );
    } else {
      return const Text(
        "Gönderilerini görmek istediğin peti seç",
      );
    }
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

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Divider(
        color: Colors.brown.shade400,
        thickness: 0.2,
        indent: 12,
        endIndent: 12,
      ),
    );
  }

  void deleteRequest(String senderId, String receiverId) {
    if (isRequestSent == true) {
      context.read<FollowCubit>().deleteFollowRequest(senderId, receiverId);

      setState(() {
        followBtnText = LocaleKeys.follow.tr();
        isRequestSent = false;
        isFollowing = false;
        requestId = "";
      });
    }
  }

  void follow(String followerId, String followedId) async {
    if (profileLock == true) {
      context.read<FollowCubit>().sentRequest(followerId, followedId);

      setState(() {
        isRequestSent = true;
        isFollowing = false;
        followBtnText = LocaleKeys.followRequestSent.tr();
      });
    } else {
      context.read<FollowCubit>().follow(followerId, followedId);

      setState(() {
        isRequestSent = false;
        followBtnText = LocaleKeys.alreadyFollowing.tr();
        isFollowing = true;
      });
    }
  }

  void textBtn() {
    if (isFollowing == true) {
      followBtnText = LocaleKeys.unfollow.tr();
    } else if (isRequestSent == true) {
      followBtnText = LocaleKeys.followRequestSent.tr();
    } else {
      followBtnText = LocaleKeys.follow.tr();
    }
  }

  void unfollow(String followerId, String followedId) {
    context.read<FollowCubit>().unfollow(followerId, followedId);

    setState(() {
      isFollowing = false;
      followBtnText = LocaleKeys.follow.tr();
    });
  }

  Widget buildPetSection(List<Pet>? pets) {
    //! PET SECTION

    if (profileLock == false || isFollowing == true) {
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
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              blurRadius: 1,
                            ),
                          ],
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://static3.depositphotos.com/1006065/229/i/450/depositphotos_2299392-stock-photo-cat.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            _buildDivider(),
            buildPetBar(context),
            _buildDivider(),
            _buildPetPosts(),
          ],
        ),
      );
    } else if (isFollowing == false && profileLock == true) {
      return SizedBox(height: 200, child: const Icon(Icons.lock_outlined));
    } else {
      return const SizedBox();
    }
  }

  Widget _buildPetPosts() {
    return BlocBuilder<PostCubit, PostState>(
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
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
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
}
