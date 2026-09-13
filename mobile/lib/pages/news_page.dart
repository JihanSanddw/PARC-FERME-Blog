import 'package:flutter/material.dart';
import 'package:mobile/pages/create_post_page.dart';
import 'package:mobile/pages/detail_post_page.dart';
import 'package:mobile/pages/calendar_page.dart';
import 'package:mobile/pages/home_page.dart';
import 'package:mobile/pages/profile_page.dart';
import 'package:mobile/pages/teams_page.dart';

import '../services/post_service.dart';
import '../models/post.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final PostService postService = PostService();

  late Future<List<Post>> posts;

  int selectedBottomNav = 1;

  int selectedCategory = 0;

  final List<String> categoryNames = [
    'ALL',
    'Race Analysis',
    'Driver',
    'Team',
    'Technology',
    'Paddock',
  ];

  @override
  void initState() {
    super.initState();

    posts = postService.getPosts();
  }

  void openHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void refreshPosts() {
    setState(() {
      posts = postService.getPosts();
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

  // =====================================================
  // OPEN CREATE
  // =====================================================

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

  Widget articleImage(String? image, {double height = 180}) {
    if (image == null || image.isEmpty) {
      return Container(
        height: height,
        width: double.infinity,
        color: const Color(0xFF1A1A1A),
        child: const Center(
          child: Icon(Icons.image_outlined, color: Colors.white54, size: 40),
        ),
      );
    }

    return Image.network(
      image,
      height: height,
      width: double.infinity,

      fit: BoxFit.cover,

      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: double.infinity,
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

  List<Post> filterPosts(List<Post> allPosts) {
    // ALL
    if (selectedCategory == 0) {
      return allPosts;
    }

    final selectedCategoryName = categoryNames[selectedCategory];

    return allPosts.where((post) {
      return post.category == selectedCategoryName;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

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
                              'Failed to load news',
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
                          SizedBox(height: 250),

                          Center(
                            child: Text(
                              'No news available',
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

                  final List<Post> allPosts = snapshot.data!;

                  final List<Post> filteredPosts = filterPosts(allPosts);

                  return RefreshIndicator(
                    color: const Color(0xFF00E5FF),

                    onRefresh: () async {
                      refreshPosts();
                    },

                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),

                      slivers: [

                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 48,

                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,

                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),

                              itemCount: categoryNames.length,

                              itemBuilder: (context, index) {
                                final bool active = selectedCategory == index;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = index;
                                    });
                                  },

                                  child: Container(
                                    margin: const EdgeInsets.only(right: 7),

                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 13,
                                    ),

                                    alignment: Alignment.center,

                                    decoration: BoxDecoration(
                                      color: active
                                          ? const Color(0xFF00E5FF)
                                          : const Color(0xFF191919),

                                      borderRadius: BorderRadius.circular(2),
                                    ),

                                    child: Text(
                                      categoryNames[index].toUpperCase(),

                                      style: TextStyle(
                                        color: active
                                            ? Colors.white
                                            : const Color(0xFF777777),

                                        fontSize: 9,

                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        if (filteredPosts.isEmpty)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(40),

                              child: Center(
                                child: Text(
                                  'No articles in this category',

                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 15,
                                  ),
                                ),
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
                              final Post post = filteredPosts[index];

                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 12,
                                ),

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
                                              height: 180,
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

                                                    fontSize: 8,

                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            12,
                                            11,
                                            12,
                                            12,
                                          ),

                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,

                                            children: [
                                              Expanded(
                                                child: Text(
                                                  post.title,

                                                  maxLines: 2,

                                                  overflow:
                                                      TextOverflow.ellipsis,

                                                  style: const TextStyle(
                                                    color: Colors.white,

                                                    fontSize: 13,

                                                    height: 1.2,

                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 10),

                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 11,
                                                      vertical: 8,
                                                    ),

                                                color: const Color(0xFF00E5FF),

                                                child: const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,

                                                  children: [
                                                    Text(
                                                      'READ',

                                                      style: TextStyle(
                                                        color: Colors.white,

                                                        fontSize: 8,

                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                    ),

                                                    SizedBox(width: 4),

                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.white,
                                                      size: 8,
                                                    ),
                                                  ],
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
                            }, childCount: filteredPosts.length),
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

  Widget _buildHeader() {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'PARC ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: 'FERMÉ',
                    style: TextStyle(
                      color: Color(0xFF00E5FF),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // IconButton(
            //   onPressed: () {},
            //   padding: EdgeInsets.zero,
            //   icon: const Icon(Icons.search, color: Colors.white70, size: 21),
            // ),

            // const SizedBox(width: 5),

            GestureDetector(
              onTap: openCreate,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF00E5FF),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              )
            ),

            const SizedBox(width: 10),

            GestureDetector(
              onTap: openProfile,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFF191919),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ),
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
          openHome();
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
