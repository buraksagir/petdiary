// ignore_for_file: use_build_context_synchronously
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../cubit/comment/comment_cubit.dart';
import '../../cubit/comment/comment_cubit_state.dart';
import '../../cubit/like/like_cubit.dart';
import '../../cubit/like/like_cubit_state.dart';
import '../../cubit/post/post_cubit.dart';
import '../../cubit/user/user_cubit.dart';
import '../../data/models/post_model.dart';
import '../../data/models/user_model.dart';
import '../../generated/locale_keys.g.dart';
import '../themes/app_theme.dart';
import '../widgets/divider.dart';
import '../widgets/snackbar.dart';
import '../widgets/text_field.dart';

class PetPostDetailsScreen extends StatefulWidget {
  const PetPostDetailsScreen(
      {super.key,
      required this.post,
      required this.index,
      required this.contextUserId,
      required this.user});

  final Post post;
  final int index;
  final String contextUserId;
  final User user;

  @override
  State<PetPostDetailsScreen> createState() => _PetPostDetailsScreenState();
}

class _PetPostDetailsScreenState extends State<PetPostDetailsScreen> {
  String? commentError;
  IconData iconData = Icons.favorite;
  IconData iconData2 = Icons.favorite_border_outlined;
  TextEditingController commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<CommentCubit>().getCommentsByPostId(widget.post.id.toString());
  }

  @override
  Widget build(BuildContext realContext) {
    return BlocProvider(
      create: (context) => SingleUserCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Post Details'),
        ),
        body: Hero(
          tag: 'post_${widget.post.id}_${widget.index}',
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  final post = widget.post;
                  int? count = post.postLikes?.length;
                  final userModel = widget.user;
                  checkIfCurrentUserLikedPost(post, widget.contextUserId);
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 6, bottom: 6, left: 8, right: 8),
                    child: Container(
                      //* Post card
                      decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.background,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              blurRadius: 3,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15)),
                      height: 455,
                      child: Column(
                        children: [
                          Row(
                            //* Post header
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundImage:
                                      NetworkImage("${userModel.photo}"),
                                ),
                              ),
                              TextButton(
                                child: Text(
                                  "${userModel.userName}",
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                ),
                                onPressed: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: ((context) => MultiBlocProvider(
                                  //           providers: [
                                  //             BlocProvider(
                                  //               create: (context) =>
                                  //                   SingleUserCubit(),
                                  //             ),
                                  //             BlocProvider(
                                  //               create: (context) =>
                                  //                   FollowCubit(),
                                  //             ),
                                  //             BlocProvider(
                                  //               create: (context) =>
                                  //                   PostCubit(),
                                  //             )
                                  //           ],
                                  //           child: ProfileScreen(
                                  //             contextUser: widget.contextUserId,
                                  //             selectedUserId:
                                  //                 post.userId.toString(),
                                  //           ),
                                  //         )),
                                  //   ),
                                  // );
                                },
                              ),
                              Builder(builder: (context) {
                                return Text(
                                  "| ${post.petName!.first}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14, // İstediğiniz boyut
                                  ),
                                );
                              }),
                              Padding(
                                //* Report button
                                padding: const EdgeInsets.only(left: 160.0),
                                child: PopupMenuButton(
                                  onSelected: (value) {
                                    SnackBar reportSnackBar = MySnackBar()
                                        .getSnackBar(
                                            "User successfully reported");
                                    value == 'report'
                                        ? ScaffoldMessenger.of(context)
                                            .showSnackBar(reportSnackBar)
                                        : '';
                                  }, //! BURAYA BAK TEXTLERİ GLOBALLEŞTİR
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'report',
                                      child: Text(LocaleKeys.reportUser.tr()),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Diğer kısım...

                          Container(
                            //* Post image
                            constraints: BoxConstraints.expand(
                              height: 300,
                              width: MediaQuery.of(context).size.width,
                            ),
                            child: Image.network(
                              post.photo ?? "",
                              fit: BoxFit.cover,
                            ),
                          ),
                          MyDivider().getDivider(),
                          Text(
                            post.text!.isNotEmpty
                                ? post.text!
                                : 'No Description',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                            maxLines: 1,
                          ),
                          MyDivider().getDivider(),
                          BlocProvider(
                            create: (context) => LikeCubit(),
                            child: Row(
                              //* Post footer
                              children: [
                                BlocBuilder<LikeCubit, LikeState>(
                                  builder: (context, state) {
                                    return IconButton(
                                      onPressed: () {
                                        if (post.isLikedByCurrentUser == true) {
                                          dislike(
                                              "${post.id}",
                                              "${post.postLikes!.firstWhere((element) => element.userId.toString() == widget.contextUserId).id}",
                                              post);
                                        } else {
                                          like("${post.id}", post);
                                        }
                                      },
                                      icon: post.isLikedByCurrentUser!
                                          ? Icon(
                                              iconData,
                                              color: AppTheme.lightTheme
                                                  .colorScheme.primary
                                                  .withGreen(75),
                                            )
                                          : Icon(iconData2),
                                    );
                                  },
                                ),
                                Text("$count"),
                                IconButton(
                                  icon: const Icon(
                                    Icons.mode_comment_outlined,
                                  ),
                                  onPressed: () {
                                    //* Comments
                                    _showCommentsModal(
                                        context, post, commentController);
                                  },
                                ),
                                BlocBuilder<CommentCubit, CommentState>(
                                  builder: (context, state) {
                                    return Text(
                                        state.comments?.length.toString() ??
                                            "0");
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 150.0, right: 10),
                                  child: createDate(post),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    //* Refresh method
    await Future.delayed(const Duration(seconds: 2));
  }

  void checkIfCurrentUserLikedPost(Post? post, String contextUser) {
    //* Already liked? method
    post?.isLikedByCurrentUser = post.postLikes?.any((element) {
      if (element.userId.toString() == widget.contextUserId) {
        return true;
      } else {
        return false;
      }
    });
  }

  void like(String postId, Post? post) {
    //* Like method
    context.read<LikeCubit>().likePost(widget.contextUserId, postId);
    setState(() {
      post?.postLikes?.add(PostLikes(
          postId: post.id, userId: int.tryParse(widget.contextUserId)));
      post?.isLikedByCurrentUser = true;
    });
  }

  Text createDate(Post post) {
    return Text(
      _formatDate(post.createDate!), // Call the formatting function
      style: AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
        fontSize: 10,
      ),
    );
  }

  void _showCommentsModal(BuildContext context, Post? post,
      TextEditingController commentController) {
    //* Comment sheet
    showModalBottomSheet(
      backgroundColor: AppTheme.lightTheme.colorScheme.background,
      isScrollControlled: true, // This allows the modal to adjust height
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => CommentCubit(),
          child: BlocBuilder<CommentCubit, CommentState>(
            builder: (context, state) {
              if (!state.isLoaded && !state.isLoading) {
                context
                    .read<CommentCubit>()
                    .getCommentsByPostId(post!.id.toString());
              }

              bool anyComment = state.comments?.isNotEmpty ?? false;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom, // Adjusts for the keyboard
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.isLoading || !state.isLoaded)
                        SizedBox(
                          height: 290, // Height for the comments container
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: post?.comments?.length ??
                                3, // Show 3 placeholders for example
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 48.0,
                                    height: 10.0,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                title: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: double.infinity,
                                    height: 10.0,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (state.isLoaded && state.comments != null)
                        Container(
                          height: 290,
                          padding: const EdgeInsets.all(12.0),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(2),
                            itemCount: state.comments?.length ?? 0,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const CircleAvatar(
                                  backgroundImage: NetworkImage(""), //!
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${state.comments?[index].userName}",
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${state.comments?[index].comment}",
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      if (state.isLoaded && state.comments == null)
                        Container(
                          height: 300,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width - 10,
                          child: Text(
                            LocaleKeys.noComments.tr(),
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width - 75,
                            height: 50,
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                            child: FieldWidget(
                              validator: validateComment,
                              errorMessage: commentError,
                              isPassword: false,
                              keyboardType: TextInputType.text,
                              label: LocaleKeys.insertComment.tr(),
                              regController: commentController,
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              iconColor: MaterialStatePropertyAll(
                                  AppTheme.lightTheme.colorScheme.primary),
                              backgroundColor: MaterialStatePropertyAll(
                                  AppTheme.lightTheme.colorScheme.background),
                            ),
                            onPressed: () {
                              String? isCommentValid =
                                  validateComment(commentController.text);
                              if (isCommentValid == null) {
                                context.read<CommentCubit>().sendComment(
                                    widget.contextUserId.toString(),
                                    post!.id.toString(),
                                    commentController.text);

                                commentController.clear();
                                _refreshComments(post.id.toString(), post);
                              }
                            },
                            child: const Icon(Icons.send_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _refreshComments(String postId, Post post) async {
    //* Refresh method
    Navigator.pop(context); // Close the comments modal
    _showCommentsModal(context, post, commentController);
  }

  String? validateComment(String? value) {
    if (value!.isNotEmpty && value.length < 2) {
      return LocaleKeys.validateComment.tr();
    }
    return null;
  }

  void dislike(String postId, String likeId, Post post) {
    //* Dislike method
    context.read<LikeCubit>().dislikePost(postId, widget.contextUserId);
    setState(() {
      post.postLikes?.removeWhere((element) {
        element.postId.toString() == postId;
        element.userId.toString() == widget.contextUserId;
        post.isLikedByCurrentUser = false;
        return true;
      });
    });
  }

  String _formatDate(String dateTimeString) {
    if (Localizations.localeOf(context) == const Locale('tr', 'TR')) {
      DateTime dateTime = DateTime.parse(dateTimeString);
      DateFormat formatter =
          DateFormat('d MMMM - HH:mm', 'tr'); // Adjust format as needed
      return formatter.format(dateTime);
    } else {
      DateTime dateTime = DateTime.parse(dateTimeString);
      DateFormat formatter =
          DateFormat('d MMMM - HH:mm', 'en'); // Adjust format as needed
      return formatter.format(dateTime);
    }
  }
}
