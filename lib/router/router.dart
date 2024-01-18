import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screen/home/home_screen.dart';
import 'constants.dart';


class MyRouter {
  // final UserNotifier userProvider;

  MyRouter();
  // MyRouter(this.userProvider);

  late final router = GoRouter(
    initialLocation: '/login',
    //첫화면설정
    errorBuilder: (context, state) {
      return const Text('Error occur');
    },
    // errorPageBuilder: (context,state){
    //   return MaterialPage<void>(child: ErrorPage());
    // },
    routes: [
      GoRoute(
          path: '/login',
          name: loginRouteName,
          builder: (context, state) {
            return const LoginScreen();
          },
          routes: [
            GoRoute(
              path: 'auth/:gubun',
              name: authRouteName,
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: AuthScreen(gubun: state.pathParameters['gubun']!,),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity:
                      CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                      child: child,
                    );
                  },
                );
              },
              routes: [
                GoRoute(
                    path: 'signup/:name/:di/:phone/:gender/:age',
                    name: signUpRouteName,
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: SignUpScreen(name: state.pathParameters['name']!,di: state.pathParameters['di']!,phone: state.pathParameters['phone']!,gender: state.pathParameters['gender']!,age: state.pathParameters['age']!,),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity:
                            CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                            child: child,
                          );
                        },
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'termsdetail/:title/:content',
                        name: termsDetailRouteName,

                        pageBuilder: (context, state) {
                          return CustomTransitionPage(
                            key: state.pageKey,
                            child: TermsDetailScreen(
                                title: state.pathParameters['title']!,
                                content: state.pathParameters['content']!),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity:
                                CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                                child: child,
                              );
                            },
                          );
                        },
                      ),
                    ]),
              ]
            ),

          ]),

      GoRoute(
        path: '/home',
        name: homeRouteName,
        builder: (context, state) {
          return const HomeScreen();
        },
        routes: [

          GoRoute(
            path: 'profile',
            name: myprofileRouteName,
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: MyProfileScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),

          GoRoute(
              path: 'notice',
              name: noticeRouteName,
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: NoticeScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity:
                      CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            routes: [
              GoRoute(
                path: 'detail/:seq',
                name:noticeDetailRouteName,
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: NoticeDetailScreen(seq:state.pathParameters['seq']!,),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity:
                        CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                        child: child,
                      );
                    },
                  );
                },
              ),
            ]
          ),

          GoRoute(
            path: 'terms',
            name: termsRouteName,
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: TermsScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                    child: child,
                  );
                },
              );
            },
            routes: [

              GoRoute(
                path: ':title/:content',
                name: gotermsDetailRouteName,

                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: TermsDetailScreen(
                        title: state.pathParameters['title']!,
                        content: state.pathParameters['content']!),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity:
                        CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                        child: child,
                      );
                    },
                  );
                },
              ),
            ]
          ),


        ]
      ),

      GoRoute(
        path: '/splash',
        name: splashRouteName,
        builder: (context, state) {
          return const SplashScreen();
        },
      )
    ],
    redirect: (context, state)  {
    //   final loggedIn = userProvider.token != null && userProvider.token != '';
    //   final inLoginPages = state.matchedLocation.contains(loginRouteName);
    //   final inProfileImagePages = state.matchedLocation.contains(profileImgRouteName);
    //   final join = userProvider.joinTF ?? false;
    //
    //   //inAuthPage && loginstate:true => go to home
    //   if (inLoginPages && loggedIn) return '/home';
    //   //notInAuth && loginstate:false => go to loginPage
    //   if ( !inLoginPages &&!loggedIn) return '/login';
    //   if (inProfileImagePages && join ) return '/login';
    //
    // },
    // refreshListenable: userProvider,
    // debugLogDiagnostics: true, //개발할때만 true, 출시할땐 false
  );
}
