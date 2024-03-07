import 'package:flutter/material.dart';

class FirstTabScreen extends StatelessWidget {
  const FirstTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
// 변경사항
    return Column(
      children: [
        const SizedBox(height: 48),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 400,
                  color: Colors.grey,
                ),
              ),
              const SliverPersistentHeader(
                  pinned: true, delegate: CategoryBreadcrumbs()),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                          (context, index) => Container(
                        height: 40,
                        // 보는 재미를 위해 인덱스에 아무 숫자나 곱한 뒤 255로
                        // 나눠 다른 색이 보이도록 함.
                        color: Color.fromRGBO((index * 45) % 255,
                            (index * 70) % 255, (index * 25), 1.0),
                      ),
                      childCount: 40))
            ],
          ),
        ),
      ],
    );
  }
}
class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // iOS에서 StatusBar의 색상을 정해주기위해 설정
    // TabBar 등을 사용하려면 Scaffold 혹은 Meterial로 감싸줘야함.
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: false,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  toolbarHeight: 48,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  title: const Text(
                    "Flutter Shopping App",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                // 변경사항
                SliverOverlapAbsorber(
                  handle:
                  NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: const SliverPersistentHeader(
                      pinned: true, delegate: TabBarDelegate()),
                ),
              ];
            },
            body: Column(
              children: [
                // SizedBox(height: 48),
                Expanded(
                  child: TabBarView(
                    children: [
                      const FirstTabScreen(),
                      Container(
                        color: Colors.redAccent,
                      ),
                      Container(
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class TabBarDelegate extends SliverPersistentHeaderDelegate {
  const TabBarDelegate();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: TabBar(
        tabs: [
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: const Text(
                "홈",
              ),
            ),
          ),
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: const Text(
                "특가",
              ),
            ),
          ),
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: const Text(
                "랭킹",
              ),
            ),
          ),
        ],
        indicatorWeight: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.black,
        indicatorColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class CategoryBreadcrumbs extends SliverPersistentHeaderDelegate {
  const CategoryBreadcrumbs();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Text("의류", style: TextStyle(color: Colors.black)),
          const SizedBox(width: 4),
          const Text(">", style: TextStyle(color: Colors.black)),
          const SizedBox(width: 4),
          const Text("전체", style: TextStyle(color: Colors.black)),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Center(child: Text("전체보기")),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
