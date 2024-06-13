import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petdiary/cubit/comment/comment_cubit.dart';

import '../../cubit/follow/follow_cubit.dart';
import '../../cubit/like/like_cubit.dart';
import '../../cubit/post/post_cubit.dart';
import '../../cubit/user/user_cubit.dart';
import '../../cubit/user/user_cubit_state.dart';
import '../../data/models/user_model.dart';
import '../../generated/locale_keys.g.dart';
import '../themes/app_theme.dart';
import 'profile_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? contextUser;
  const SearchScreen({super.key, required this.contextUser});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext mainContext) {
    super.build(mainContext);
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<SingleUserCubit, SingleUserState>(
          listener: (context, state) {},
          builder: (context, state) {
            List<User> searchList = [];
            if (state.searchUserListModel?.isNotEmpty == true) {
              searchList = state.searchUserListModel ?? [];
            }

            if (searchList.any(
                (element) => element.id.toString() == widget.contextUser!)) {
              searchList.removeWhere(
                  (element) => element.id.toString() == widget.contextUser);
            } else {}
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    textAlign: TextAlign.left,
                    autofocus: false,
                    onSubmitted: (val) {},
                    onChanged: (val) {
                      if (searchController.text.isNotEmpty) {
                        context
                            .read<SingleUserCubit>()
                            .getUserByUserName(searchController.text);
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(top: 10, bottom: 10),
                      fillColor: AppTheme.lightTheme.colorScheme.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      hintText: LocaleKeys.search.tr(),
                      hintStyle: AppTheme.lightTheme.textTheme.bodyMedium,
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                if (state.isSearchLoading)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                if (state.isSearchLoaded)
                  Expanded(
                    child: ListView.builder(
                      itemCount: searchList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.2,
                                    color: AppTheme
                                        .lightTheme.colorScheme.primary),
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: ((context) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider(
                                              create: (context) =>
                                                  SingleUserCubit(),
                                            ),
                                            BlocProvider(
                                              create: (context) =>
                                                  FollowCubit(),
                                            ),
                                            BlocProvider(
                                              create: (context) => PostCubit(),
                                            ),
                                            BlocProvider(
                                              create: (context) => LikeCubit(),
                                            ),
                                            BlocProvider(
                                              create: (context) =>
                                                  CommentCubit(),
                                            ),
                                          ],
                                          child: ProfileScreen(
                                            contextUser: widget.contextUser,
                                            selectedUserId:
                                                searchList[index].id.toString(),
                                          ),
                                        )),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 20,
                                backgroundImage: searchList[index].photo != null
                                    ? NetworkImage(
                                        searchList[index].photo ?? "")
                                    : const NetworkImage(
                                        "https://i.hizliresim.com/nxttoxc.png"),
                              ),
                              title: Text(
                                "${state.searchUserListModel?[index].userName}",
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
