import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:petdiary/cubit/auth/login_cubit.dart';
import 'package:petdiary/cubit/follow/follow_cubit.dart';
import 'package:petdiary/cubit/message/message_cubit.dart';
import 'package:petdiary/cubit/pet/pet_cubit.dart';
import 'package:petdiary/cubit/post/post_cubit.dart';
import 'package:petdiary/cubit/user/user_cubit.dart';
import 'package:petdiary/presentation/screens/home_screen.dart';
import 'package:petdiary/presentation/screens/my_profile_screen.dart';
import 'package:petdiary/presentation/screens/search_screen.dart';
import 'package:petdiary/presentation/themes/app_theme.dart';
import '../../cubit/comment/comment_cubit.dart';
import '../../cubit/like/like_cubit.dart';
import '../../data/models/user_model.dart';
import 'post_share_screen.dart';

class RootScreen extends StatefulWidget {
  final String contextUserId;
  final User? contextUser;
  const RootScreen({super.key, this.contextUser, required this.contextUserId});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PostCubit()),
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => SingleUserCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => LikeCubit()),
        BlocProvider(create: (context) => MyPostCubit()),
        BlocProvider(create: (context) => MyUserCubit()),
        BlocProvider(create: (context) => FollowCubit()),
        BlocProvider(create: (context) => CommentCubit()),
        BlocProvider(create: (context) => PetCubit()),
        BlocProvider(create: (context) => MessageCubit()),
      ],
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            HomeScreen(
              contextUserId: widget.contextUserId,
            ),
            SearchScreen(contextUser: widget.contextUserId),
            PostShareScreen(
              contextUser: widget.contextUserId,
              petTags: const ["1", "2", "3"],
            ),
            MyProfileScreen(contextUser: widget.contextUserId),
          ],
        ),
        bottomNavigationBar: SnakeNavigationBar.color(
          backgroundColor: AppTheme.lightTheme.colorScheme.background,
          unselectedItemColor: AppTheme.lightTheme.colorScheme.primary,
          snakeViewColor: AppTheme.lightTheme.colorScheme.primary,
          elevation: 16,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 25), label: 'Home'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.search, size: 28), label: 'Ara'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined, size: 27),
                label: 'Post Share'),
            BottomNavigationBarItem(
              icon: widget.contextUser?.photo != null
                  ? CircleAvatar(
                      radius: _currentIndex != 3 ? 17 : 24,
                      backgroundImage:
                          NetworkImage(widget.contextUser?.photo ?? ""),
                    )
                  : const Icon(Icons.person, size: 27),
              label: 'Profile',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              );
            });
          },
        ),
      ),
    );
  }
}
