import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/pages/create_post_page.dart';
import 'package:mobile/pages/detail_post_page.dart';
import 'package:mobile/pages/news_page.dart';
import 'package:mobile/pages/calendar_page.dart';
import 'package:mobile/pages/profile_page.dart';
import 'package:mobile/pages/teams_page.dart';

import 'package:mobile/services/post_service.dart';
import '../models/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PostService postService = PostService();

  late Future<List<Post>> posts;

  int selectedBottomNav = 0;

  int trendingIndex = 0;

  Timer? trendingTimer;

  List<Post> trendingPosts = [];

  @override
  void initState() {
    super.initState();

    posts = postService.getPosts();
  }

  @override
  void dispose() {
    trendingTimer?.cancel();

    super.dispose();
  }

  void refreshPosts() {
    setState(() {
      posts = postService.getPosts();
    });
  }

  void startTrendingTimer() {
    if (trendingTimer != null) {
      return;
    }

    if (trendingPosts.length <= 1) {
      return;
    }

    trendingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (trendingPosts.isEmpty) {
        return;
      }

      setState(() {
        trendingIndex = (trendingIndex + 1) % trendingPosts.length;
      });
    });
  }

  Future<void> openDetail(Post post) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPostPage(postId: post.idPost),
      ),
    );

    if (result == true) {
      refreshPosts();
    }
  }

  Future<void> openCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePostPage()),
    );

    if (result == true) {
      refreshPosts();
    }
  }

  Future<void> openNews() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewsPage()),
    );

    if (result == true) {
      refreshPosts();
    }
  }

  void openCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CalendarPage()),
    );
  }

  void openTeams() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TeamsPage()),
    );
  }

  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  Widget articleImage(
    String? image, {
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
  }) {
    if (image == null || image.isEmpty) {
      return Container(
        height: height,
        width: width ?? double.infinity,
        color: const Color(0xFF1A1A1A),
        child: const Center(
          child: Icon(Icons.image_outlined, color: Colors.white54, size: 40),
        ),
      );
    }

    return Image.network(
      image,
      height: height,
      width: width ?? double.infinity,

      fit: fit,

      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: width ?? double.infinity,
          color: const Color(0xFF1A1A1A),
          child: const Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: Colors.white54,
              size: 40,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),

              child: Row(
                children: [
                  // LOGO
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'PARC ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        TextSpan(
                          text: 'FERMÉ',
                          style: TextStyle(
                            color: Color(0xFF00E5FF),
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(
                  //     Icons.search,
                  //     color: Colors.white,
                  //     size: 24,
                  //   ),
                  // ),

                  GestureDetector(
                    onTap: openCreate,
                    child: Container(
                      width: 34,
                      height: 34,

                      decoration: BoxDecoration(
                        color: const Color(0xFF00E5FF),
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  GestureDetector(
                    onTap: openProfile,
                    child: Container(
                      width: 34,
                      height: 34,

                      decoration: const BoxDecoration(
                        color: Color(0xFF252525),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: FutureBuilder<List<Post>>(
                future: posts,

                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00E5FF),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: 50,
                            ),

                            const SizedBox(height: 16),

                            const Text(
                              'Failed to load articles',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              '${snapshot.error}',

                              textAlign: TextAlign.center,

                              style: const TextStyle(color: Colors.white54),
                            ),

                            const SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: refreshPosts,

                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return RefreshIndicator(
                      color: const Color(0xFF00E5FF),

                      onRefresh: () async {
                        refreshPosts();
                      },

                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),

                        children: const [
                          SizedBox(height: 300),

                          Center(
                            child: Text(
                              'No articles available',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final List<Post> postList = snapshot.data!;

                  final List<Post> featuredPosts = postList
                      .where((post) => post.isFeatured)
                      .toList();

                  trendingPosts = featuredPosts;

                  if (trendingPosts.isEmpty) {
                    trendingIndex = 0;
                  } else if (trendingIndex >= trendingPosts.length) {
                    trendingIndex = 0;
                  }

                  startTrendingTimer();

                  final Post? trendingPost = trendingPosts.isNotEmpty
                      ? trendingPosts[trendingIndex]
                      : null;

                  final List<Post> latestPosts = postList
                      .where((post) => !post.isFeatured)
                      .toList();

                  return RefreshIndicator(
                    color: const Color(0xFF00E5FF),

                    onRefresh: () async {
                      refreshPosts();
                    },

                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),

                      slivers: [

                        if (trendingPost != null)
                          SliverToBoxAdapter(
                            child: Center(
                              // padding: const EdgeInsets.symmetric(
                              //   horizontal: 20,
                              // ),
                              child: GestureDetector(
                                onTap: () {
                                  openDetail(trendingPost);
                                },

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),

                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 900),

                                    switchInCurve: Curves.easeInOut,

                                    switchOutCurve: Curves.easeInOut,

                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },

                                    child: AspectRatio(
                                      key: ValueKey(trendingPost.idPost),

                                      aspectRatio: 4 / 4,

                                      child: _buildTrendingContent(
                                        trendingPost,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        if (trendingPosts.length > 1)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: List.generate(trendingPosts.length, (
                                  index,
                                ) {
                                  final bool active = index == trendingIndex;

                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),

                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),

                                    width: active ? 18 : 7,

                                    height: 7,

                                    decoration: BoxDecoration(
                                      color: active
                                          ? const Color(0xFF00E5FF)
                                          : const Color(0xFF555555),

                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),

                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),

                            child: Row(
                              children: [
                                const Text(
                                  'LATEST ARTICLES',

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),

                                const Spacer(),

                                GestureDetector(
                                  onTap: openNews,

                                  child: const Text(
                                    'SEE ALL',

                                    style: TextStyle(
                                      color: Color(0xFF00E5FF),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),

                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final Post post = latestPosts[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),

                                child: GestureDetector(
                                  onTap: () {
                                    openDetail(post);
                                  },

                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF111111),

                                      borderRadius: BorderRadius.circular(4),
                                    ),

                                    clipBehavior: Clip.antiAlias,

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [

                                        Stack(
                                          children: [
                                            articleImage(
                                              post.image,
                                              height: 190,
                                            ),

                                            Positioned(
                                              top: 10,
                                              left: 10,

                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 7,
                                                      vertical: 4,
                                                    ),

                                                color: const Color(0xFF00E5FF),

                                                child: Text(
                                                  post.category.toUpperCase(),

                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(12),

                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  post.title,

                                                  maxLines: 2,

                                                  overflow:
                                                      TextOverflow.ellipsis,

                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 10),

                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 9,
                                                    ),

                                                color: const Color(0xFF00E5FF),

                                                child: const Text(
                                                  'READ',

                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }, childCount: latestPosts.length),
                          ),
                        ),

                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTrendingContent(Post post) {
    return Stack(
      fit: StackFit.expand,

      children: [

        articleImage(
          post.image,

          width: double.infinity,

          fit: BoxFit.cover,
        ),

        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,

              stops: [0.0, 0.45, 1.0],

              colors: [
                Colors.transparent,
                Color(0x22000000),
                Color(0xF5000000),
              ],
            ),
          ),
        ),

        Positioned(
          left: 16,
          right: 16,
          bottom: 18,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),

                color: const Color(0xFF00E5FF),

                child: Text(
                  post.category.toUpperCase(),

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                post.title,

                maxLines: 3,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 10),

              // EXCERPT
              if (post.excerpt != null)
                Text(
                  post.excerpt!,

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF090909),

        border: Border(top: BorderSide(color: Color(0xFF242424), width: 1)),
      ),

      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              _buildNavItem(icon: Icons.home_rounded, label: 'HOME', index: 0),

              _buildNavItem(
                icon: Icons.article_outlined,
                label: 'NEWS',
                index: 1,
              ),

              _buildNavItem(
                icon: Icons.calendar_month_outlined,
                label: 'CALENDAR',
                index: 2,
              ),

              _buildNavItem(
                icon: Icons.groups_outlined,
                label: 'TEAMS',
                index: 3,
              ),

              _buildNavItem(
                icon: Icons.person_outline,
                label: 'PROFILE',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = selectedBottomNav == index;

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          return;
        }

        if (index == 1) {
          openNews();
          return;
        }

        if (index == 2) {
          openCalendar();
          return;
        }

        if (index == 3) {
          openTeams();
          return;
        }

        if (index == 4) {
          openProfile();
          return;
        }

        setState(() {
          selectedBottomNav = index;
        });
      },
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 21,
              color: isSelected
                  ? const Color(0xFF00E5FF)
                  : const Color(0xFF777777),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF00E5FF)
                    : const Color(0xFF777777),
                fontSize: 8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
