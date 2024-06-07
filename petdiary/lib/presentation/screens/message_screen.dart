import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petdiary/cubit/message/message_cubit.dart';
import 'package:petdiary/cubit/user/user_cubit.dart';
import 'package:petdiary/presentation/screens/home_screen.dart';
import 'package:petdiary/presentation/widgets/message_bubble.dart';
import 'package:shimmer/shimmer.dart';

import '../../cubit/message/message_cubit_state.dart';
import '../../cubit/user/user_cubit_state.dart';
import '../../data/models/message_model.dart';
import '../themes/app_theme.dart';

class MessageScreen extends StatefulWidget {
  final String? contextUserId;
  const MessageScreen({super.key, required this.contextUserId});

  @override
  // ignore: library_private_types_in_public_api
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with AutomaticKeepAliveClientMixin {
  List<Message>? messages;
  String? selectedUserId;
  String? selectedUserName;
  final PageController _pageController = PageController();
  StreamController<List<Widget>>? _userTilesStreamController;

  @override
  void initState() {
    super.initState();
    _userTilesStreamController = StreamController<List<Widget>>();
    context.read<MessageCubit>().getAllMessagesByUserId(widget.contextUserId!);
  }

  @override
  void dispose() {
    _userTilesStreamController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.background,
        title: Text(
          selectedUserName ?? 'Mesajlar',
          style: AppTheme.lightTheme.textTheme.bodyLarge,
        ),
        leading: selectedUserId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedUserId = null;
                    selectedUserName = null;
                    _userTilesStreamController?.close();
                    _userTilesStreamController =
                        StreamController<List<Widget>>();
                    _pageController.jumpToPage(0);
                  });
                },
              )
            : null,
      ),
      body: PageView(
        controller: _pageController,
        children: [
          _pageController.initialPage != 0
              ? HomeScreen(contextUserId: widget.contextUserId)
              : BlocBuilder<MessageCubit, MessageState>(
                  builder: (context, state) {
                    if (state.isLoaded) {
                      messages = state.messageListModel;
                      if (messages!.isNotEmpty) {
                        Set<String?> uniqueUserIds = {};
                        for (var message in messages!) {
                          uniqueUserIds.add(message.senderId);
                          uniqueUserIds.add(message.receiverId);
                        }

                        _fetchUsersSequentially(context, uniqueUserIds);

                        return StreamBuilder<List<Widget>>(
                          stream: _userTilesStreamController!.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text(
                                      'Kullanıcılar yüklenirken bir hata oluştu'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return shimmers();
                            } else {
                              return ListView(children: snapshot.data!);
                            }
                          },
                        );
                      } else {
                        return shimmers();
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
          BlocBuilder<MessageCubit, MessageState>(
            builder: (context, state) {
              if (selectedUserId == null) {
                return const Center(child: Text('Bir kullanıcı seçin'));
              }
              if (state.isLoaded) {
                messages = state.messageListModel;
                if (messages!.isNotEmpty) {
                  return ListView(
                    children: messages!
                        .where((message) =>
                            (message.senderId == selectedUserId ||
                                message.receiverId == selectedUserId))
                        .map((message) => MessageBubble(
                              message: message,
                              isMe: message.senderId == widget.contextUserId,
                            ))
                        .toList(),
                  );
                } else {
                  return const Center(child: Text('Mesaj bulunamadı'));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  SizedBox shimmers() {
    return SizedBox(
      height: 290,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 4,
        itemBuilder: (context, index) {
          return ListTile(
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
    );
  }

  Future<void> _fetchUsersSequentially(
      BuildContext context, Set<String?> uniqueUserIds) async {
    List<Widget> userTiles = [];

    for (var userId in uniqueUserIds) {
      var userCubit = SingleUserCubit();

      await userCubit.getUserById(userId!);

      userTiles.add(
        BlocProvider<SingleUserCubit>.value(
          value: userCubit,
          child: BlocBuilder<SingleUserCubit, SingleUserState>(
            builder: (userContext, userState) {
              if (userState.isLoaded) {
                var user = userState.userListModel![0];
                if (user.userName != null &&
                    user.id.toString() != widget.contextUserId) {
                  return ListTile(
                    title: Text(user.userName ?? 'Unknown'),
                    onTap: () {
                      setState(() {
                        selectedUserId = user.id.toString();
                        selectedUserName = user.userName;
                        _pageController.jumpToPage(1);
                      });
                    },
                  );
                } else {
                  return user.id.toString() != widget.contextUserId
                      ? const ListTile(
                          title: Text('User not found'),
                        )
                      : const SizedBox();
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      );
    }

    _userTilesStreamController?.add(userTiles);
  }

  @override
  bool get wantKeepAlive => true;
}
