import 'package:buycott/screen/login/login_screen.dart';
import 'package:buycott/screen/map/map_screen.dart';
import 'package:buycott/screen/myprofile/my_profile_edit_screen.dart';
import 'package:buycott/screen/myprofile/my_store_register_screen.dart';
import 'package:buycott/screen/myprofile/my_review_screen.dart';
import 'package:buycott/screen/myprofile/member_drop_screen.dart';
import 'package:buycott/screen/notice/notice_detail_screen.dart';
import 'package:buycott/screen/notice/notice_screen.dart';
import 'package:buycott/screen/search/search_screen.dart';
import 'package:buycott/screen/store/review_write_screen.dart';
import 'package:buycott/screen/store/store_detail_screen.dart';
import 'package:buycott/screen/term/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screen/login/sign_up_screen.dart';
import '../screen/main/main_screen.dart';
import '../screen/store/store_add_screen.dart';
import '../states/user_notifier.dart';
import '../constants/constants.dart';
import '../widgets/UnanimatedPageRoute.dart';


class MyRouter {
  final UserNotifier userProvider;

  MyRouter(this.userProvider);

  late final router = GoRouter(
    initialLocation: '/main',
    //첫화면설정
    errorBuilder: (context, state) {
      return const Text('Error occur');
    },
    // errorPageBuilder: (context,state){
    //   return MaterialPage<void>(child: ErrorPage());
    // },
    routes: [
      GoRoute(
          path: '/main',
          name: mainRouteName,
          builder: (context, state) {
            return const MainScreen();
          },
          routes: [

            GoRoute(
              path: searchRouteName,
              name: searchRouteName,
              builder: (context, state) => const SearchScreen(),
              pageBuilder: defaultPageBuilder(const SearchScreen()),
            ),

            GoRoute(
              path: myStoreRegisterRouteName,
              name: myStoreRegisterRouteName,
              builder: (context, state) => const MyStoreRegisterScreen(),
              pageBuilder: defaultPageBuilder(const MyStoreRegisterScreen()),
            ),

            GoRoute(
              path: myReviewRouteName,
              name: myReviewRouteName,
              builder: (context, state) => const MyReviewScreen(),
              pageBuilder: defaultPageBuilder(const MyReviewScreen()),
            ),

            GoRoute(
              path: '$termsRouteName/:title',
              name: termsRouteName,
              pageBuilder: (context, state) {
                return customTransitionPage(
                    state, TermsScreen(title: state.pathParameters['title']!));
              },
            ),

            GoRoute(
              path: '$storeDetailRouteName/:storeSrno',
              name: storeDetailRouteName,
              pageBuilder: (context, state) {
                return customTransitionPage(
                    state, StoreDetailScreen(storeSrno: state.pathParameters['storeSrno']!));
              },
              routes: [
                GoRoute(
                    path: reviewWriteRouteName,
                    name: reviewWriteRouteName,
                    pageBuilder: (context, state) {
                      return customTransitionPage(
                          state, ReviewWriteScreen(storeSrno: state.pathParameters['storeSrno']!));
                    },
                ),
              ]
            ),

            GoRoute(
              path: storeAddRouteName,
              name: storeAddRouteName,
              builder: (context, state) => const StoreAddScreen(),
              pageBuilder: defaultPageBuilder(const StoreAddScreen()),
            ),

            GoRoute(
              path: myProfileEditRouteName,
              name: myProfileEditRouteName,
              builder: (context, state) => const MyProfileEditScreen(),
              pageBuilder: defaultPageBuilder(const MyProfileEditScreen()),
              routes: [
                GoRoute(
                  path: memberDropRouteName,
                  name: memberDropRouteName,
                  builder: (context, state) => const MemberDropScreen(),
                  pageBuilder: defaultPageBuilder(const MemberDropScreen()),
                ),
              ]
            ),

            GoRoute(
              path: noticeRouteName,
              name: noticeRouteName,
              builder: (context, state) => const NoticeScreen(),
              pageBuilder: defaultPageBuilder(const NoticeScreen()),
              routes: [
                GoRoute(
                  path: '$noticeDetailRouteName/:subject/:content/:date',
                  name: noticeDetailRouteName,
                  pageBuilder: (context, state) {
                    return customTransitionPage(
                        state, NoticeDetailScreen(subject:state.pathParameters['subject']!,content: state.pathParameters['content']!,date: state.pathParameters['date']!,));
                  },
                ),

              ]
            ),

            GoRoute(
                path: loginRouteName,
                name: loginRouteName,
                builder: (context, state) => const LoginScreen(),
                pageBuilder: defaultPageBuilder(const LoginScreen()),
                routes: [
                  GoRoute(
                    path: '$signUpRouteName/:userId/:signType',
                    name: signUpRouteName,
                    pageBuilder: (context, state) {
                      return customTransitionPage(
                          state, SignUpScreen(userId:state.pathParameters['userId']!,signType: state.pathParameters['signType']!,));
                    },
                  ),
                ]
            ),

          ]),


      // GoRoute(
      //   path: '/splash',
      //   name: splashRouteName,
      //   builder: (context, state) {
      //     return const SplashScreen();
      //   },
      // )
    ],
    redirect: (context, state) {
      // final loggedIn = userProvider.token != null && userProvider.token != '';
      // final inLoginPages = state.matchedLocation.contains(loginRouteName);
      // final inProfileImagePages = state.matchedLocation.contains(profileImgRouteName);
      // final join = userProvider.joinTF ?? false;
      //
      // //inAuthPage && loginstate:true => go to home
      // if (inLoginPages && loggedIn) return '/home';
      // //notInAuth && loginstate:false => go to loginPage
      // if ( !inLoginPages &&!loggedIn) return '/login';
      // if (inProfileImagePages && join ) return '/login';

    },
    // refreshListenable: userProvider,
    debugLogDiagnostics: true, //개발할때만 true, 출시할땐 false
  );


}