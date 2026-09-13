import 'package:flutter/material.dart';

import 'package:mobile/constants/team_colors.dart';
import 'package:mobile/pages/create_post_page.dart';
import 'package:mobile/pages/home_page.dart';
import 'package:mobile/pages/profile_page.dart';
import 'package:mobile/pages/team_detail_page.dart';
import 'package:mobile/pages/news_page.dart';
import 'package:mobile/pages/calendar_page.dart';

import 'package:mobile/services/team_service.dart';
import 'package:mobile/services/post_service.dart';
import 'package:mobile/models/team.dart';
import 'package:mobile/models/post.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  final PostService postService = PostService();

  final TeamService teamService = TeamService();

  late Future<List<Team>> teams;

  late Future<List<Post>> posts;

  int selectedBottomNav = 3;

  @override
  void initState() {
    super.initState();

    teams = teamService.getTeams();
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

  void openTeam(Team team) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TeamDetailPage(team: team)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),

      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            _buildHeader(),

            Expanded(
              child: FutureBuilder<List<Team>>(
                future: teams,

                builder: (context, snapshot) {
                  // LOADING
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
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Failed to load teams\n\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No teams available',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final teamList = snapshot.data!;

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),

                    children: [
                      const Text(
                        '2026 SEASON',
                        style: TextStyle(
                          color: Color(0xFF00E5FF),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'CONSTRUCTORS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 22),

                      ...teamList.map((team) => _buildTeamCard(team)),
                    ],
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

  Widget _buildTeamCard(Team team) {
    final teamColor = TeamColors.getColor(team.name);

    return GestureDetector(
      onTap: () {
        openTeam(team);
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),

        decoration: BoxDecoration(
          color: const Color(0xFF111111),

          border: Border(left: BorderSide(color: teamColor, width: 4)),
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),

          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: teamColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(3),
                ),

                child: Text(
                  team.shortName,

                  style: TextStyle(
                    color: teamColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      team.name,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      team.country,

                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right, color: teamColor.withOpacity(0.6)),
            ],
          ),
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
