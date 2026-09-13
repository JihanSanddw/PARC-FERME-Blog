import 'package:flutter/material.dart';

import 'package:mobile/pages/home_page.dart';
import 'package:mobile/pages/news_page.dart';
import 'package:mobile/pages/profile_page.dart';
import 'package:mobile/pages/teams_page.dart';
import 'package:mobile/pages/create_post_page.dart';
import 'package:mobile/services/post_service.dart';
import 'package:mobile/services/race_service.dart';
import '../models/race.dart';
import '../models/post.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final PostService postService = PostService();

  final RaceService raceService = RaceService();

  late Future<List<Race>> races;

  late Future<List<Post>> posts;

  int selectedBottomNav = 2;

  @override
  void initState() {
    super.initState();

    races = raceService.getUpcomingRaces();
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

  Future<void> refreshRaces() async {
    setState(() {
      races = raceService.getUpcomingRaces();
    });

    await races;
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);

    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    return '${months[parsedDate.month - 1]} '
        '${parsedDate.day}, '
        '${parsedDate.year}';
  }

  int selectedTab = 0;

  void selectTab(int index) {
    setState(() {
      selectedTab = index;

      if (index == 0) {
        races = raceService.getUpcomingRaces();
      } else {
        races = raceService.getCompletedRaces();
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: FutureBuilder<List<Race>>(
                future: races,
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
                        child: Text(
                          'Failed to load race calendar.\n\n'
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No upcoming races.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  final raceList = snapshot.data!;

                  return RefreshIndicator(
                    color: const Color(0xFF00E5FF),
                    backgroundColor: const Color(0xFF161616),
                    onRefresh: refreshRaces,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      children: [
                        _buildSeasonTitle(),
                        const SizedBox(height: 20),

                        _buildTabs(),

                        const SizedBox(height: 16),

                        ...List.generate(raceList.length, (index) {
                          final race = raceList[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _buildRaceCard(
                              race,
                              isNext: selectedTab == 0 && index == 0,
                            ),
                          );
                        }),
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

  Widget _buildSeasonTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          'RACE CALENDAR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                selectTab(0);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: selectedTab == 0
                      ? const Color(0xFF00E5FF)
                      : Colors.transparent,
                  border: selectedTab == 0
                      ? Border.all(color: Colors.white, width: 1)
                      : null,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text(
                  'UPCOMING',
                  style: TextStyle(
                    color: selectedTab == 0 ? Colors.white : Colors.white24,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () {
                selectTab(1);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: selectedTab == 1
                      ? const Color(0xFF00E5FF)
                      : Colors.transparent,
                  border: selectedTab == 1
                      ? Border.all(color: Colors.white, width: 1)
                      : null,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text(
                  'COMPLETED',
                  style: TextStyle(
                    color: selectedTab == 1 ? Colors.white : Colors.white24,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRaceCard(Race race, {required bool isNext}) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(color: Color(0xFF111111)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: double.infinity,
            color: isNext ? const Color(0xFF00E5FF) : const Color(0xFF1A1A1A),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'R',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  '${race.round}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${race.country.substring(0, 2).toUpperCase()}  ${formatDate(race.raceDate)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.7,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    race.grandPrix,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    race.circuit,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isNext)
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00E5FF)),
              ),
              child: const Text(
                'NEXT',
                style: TextStyle(
                  color: Color(0xFF00E5FF),
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
        ],
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

  // =====================================================
  // NAV ITEM
  // =====================================================

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
