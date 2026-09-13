import 'package:flutter/material.dart';

import 'package:mobile/pages/home_page.dart';
import 'package:mobile/pages/login_page.dart';
import 'package:mobile/pages/news_page.dart';
import 'package:mobile/pages/calendar_page.dart';
import 'package:mobile/pages/teams_page.dart';
import 'package:mobile/pages/create_post_page.dart';
import 'package:mobile/services/post_service.dart';
import '../models/post.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PostService postService = PostService();

  late Future<List<Post>> posts;

  String userName = 'Jihan Santika Dewi';
  String userEmail = 'jihansanddw@gmail.com';

  void refreshPosts() {
    setState(() {
      posts = postService.getPosts();
    });
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

  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  void openHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void openNews() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewsPage(),
      ),
    );
  }

  void openCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CalendarPage(),
      ),
    );
  }

  void openTeams() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TeamsPage(),
      ),
    );
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'PROFILE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Your PARC FERMÉ account.',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111111),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: const Color(0xFF242424),
                        ),
                      ),
                      child: Row(
                        children: [

                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: const Color(0xFF191919),
                              borderRadius:
                                  BorderRadius.circular(3),
                              border: Border.all(
                                color: const Color(0xFF00E5FF),
                              ),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Color(0xFF00E5FF),
                              size: 30,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Text(
                                  userName,
                                  maxLines: 2,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  userEmail,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 10,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 4,
                                  ),
                                  color:
                                      const Color(0xFF00E5FF),
                                  child: const Text(
                                    'PADDOCK MEMBER',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 7,
                                      fontWeight:
                                          FontWeight.w900,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'ACCOUNT',
                      style: TextStyle(
                        color: Color(0xFF00E5FF),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'EDIT PROFILE',
                      subtitle: 'Update your name and email',
                    ),

                    const SizedBox(height: 8),

                    _buildMenuItem(
                      icon: Icons.article_outlined,
                      title: 'MY ARTICLES',
                      subtitle: 'View your published articles',
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'APP',
                      style: TextStyle(
                        color: Color(0xFF00E5FF),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'SETTINGS',
                      subtitle: 'Manage app preferences',
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: OutlinedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(
                          Icons.logout,
                          size: 16,
                        ),
                        label: const Text(
                          'LOG OUT',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: Color(0xFF333333),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
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
          //   icon: const Icon(Icons.search, color: Colors.white70, size: 21),
          // ),
          // const SizedBox(width: 2),

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
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(3),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: const Color(0xFF242424),
          ),
        ),
        child: Row(
          children: [

            Icon(
              icon,
              color: const Color(0xFF00E5FF),
              size: 21,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Colors.white38,
              size: 18,
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
        border: Border(
          top: BorderSide(
            color: Color(0xFF242424),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 7,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: [

              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'HOME',
                index: 0,
              ),

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
    // PROFILE = index 4
    final bool isSelected = index == 4;

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
          return;
        }
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