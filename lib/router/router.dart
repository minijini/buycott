import 'package:buycott/screen/login/login_screen.dart';
import 'package:buycott/screen/map/map_screen.dart';
import 'package:buycott/screen/myprofile/my_store_register_screen.dart';
import 'package:buycott/screen/myprofile/my_review_screen.dart';
import 'package:buycott/screen/store/store_detail_screen.dart';
import 'package:buycott/screen/term/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screen/login/sign_up_screen.dart';
import '../screen/main/main_screen.dart';
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
              path: storeDetailRouteName,
              name: storeDetailRouteName,
              builder: (context, state) => const StoreDetailScreen(),
              pageBuilder: defaultPageBuilder(const StoreDetailScreen()),
            ),

            GoRoute(
                path: loginRouteName,
                name: loginRouteName,
                builder: (context, state) => const LoginScreen(),
                pageBuilder: defaultPageBuilder(const LoginScreen()),
                routes: [
                  GoRoute(
                    path: '$signUpRouteName/:userId',
                    name: signUpRouteName,
                    pageBuilder: (context, state) {
                      return customTransitionPage(
                          state, SignUpScreen(userId:state.pathParameters['userId']!));
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