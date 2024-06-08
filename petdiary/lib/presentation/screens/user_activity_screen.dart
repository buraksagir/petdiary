import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/follow/follow_cubit.dart';
import '../../cubit/follow/follow_cubit_state.dart';
import '../../generated/locale_keys.g.dart';
import '../themes/app_theme.dart';
import '../widgets/snackbar.dart';

class UserActivityScreen extends StatefulWidget {
  final String? contextUserId;
  const UserActivityScreen({super.key, required this.contextUserId});

  @override
  State<UserActivityScreen> createState() => _UserActivityScreenState();
}

class _UserActivityScreenState extends State<UserActivityScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int? requestCount;

  @override
  void initState() {
    super.initState();
    context
        .read<FollowCubit>()
        .getUsersFollowRequests(widget.contextUserId ?? "");
  }

  void _refresh() {
    super.initState();
    context
        .read<FollowCubit>()
        .getUsersFollowRequests(widget.contextUserId ?? "");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 15,
          forceMaterialTransparency: true,
          title: Text(
            LocaleKeys.followRequests.tr(),
            style: AppTheme.lightTheme.textTheme.bodyLarge,
          ),
        ),
        body: BlocConsumer<FollowCubit, FollowState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.isLoaded && state.followRequests != null) {
              requestCount = state.followRequests?.length;
              if (state.followRequests!.isNotEmpty) {
                return SingleChildScrollView(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: state.followRequests?.length ?? 0,
                        itemBuilder: (context, index) {
                          final followRequest = state.followRequests![index];
                          return ListTile(
                            onTap: () {},
                            trailing: Wrap(
                              direction: Axis.vertical,
                              children: [
                                ElevatedButton(
                                  style: const ButtonStyle(
                                      elevation: MaterialStatePropertyAll(7)),
                                  onPressed: () {
                                    acceptFollowRequest(widget.contextUserId!,
                                        followRequest.id.toString(), context);
                                    _refresh();
                                  },
                                  child: Text(
                                    LocaleKeys.accept.tr(),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                ElevatedButton(
                                  style: const ButtonStyle(
                                      elevation: MaterialStatePropertyAll(7)),
                                  onPressed: () {
                                    rejectFollowRequest(widget.contextUserId!,
                                        followRequest.id.toString(), context);
                                    _refresh();
                                  },
                                  child: Text(
                                    LocaleKeys.reject.tr(),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              "${followRequest.username}",
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  followRequest.profilePhoto ?? ""),
                            ),
                          );
                        },
                      )),
                );
              } else {
                return Center(
                  child: Text(
                    LocaleKeys.noActivity.tr(),
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                );
              }
            } else if (state.isLoading) {
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
              return Center(
                child: Text(
                  LocaleKeys.noActivity.tr(),
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              );
            }
          },
        ));
  }

  void acceptFollowRequest(
      String followerId, String requestId, BuildContext context) {
    SnackBar snackBar =
        MySnackBar().getSnackBar(LocaleKeys.followRequestAccepted.tr());
    context.read<FollowCubit>().acceptFollowRequest(followerId, requestId);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void rejectFollowRequest(
      String followerId, String requestId, BuildContext context) {
    SnackBar snackBar =
        MySnackBar().getSnackBar(LocaleKeys.followRequestRejected.tr());
    context.read<FollowCubit>().rejectFollowRequest(followerId, requestId);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
