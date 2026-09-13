import 'package:flutter/material.dart';
import 'package:mobile/constants/team_colors.dart';

import '../models/driver.dart';
import '../models/team.dart';

class DriverDetailPage extends StatelessWidget {
  final Driver driver;
  final Team team;

  const DriverDetailPage({
    super.key,
    required this.driver,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
      // final teamColor = TeamColors.getColor(team.name);

    return Scaffold(
      backgroundColor: const Color(0xFF080808),

      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 76,
                ),
              ),
              
              _buildHero(),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    20,
                    16,
                    100,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      _buildDriverNumber(),

                      const SizedBox(height: 4),

                      Text(
                        driver.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // _buildStats(),

                      // const SizedBox(height: 20),

                      _buildProfile(),

                      const SizedBox(height: 16),

                      _buildInfo(),

                      const SizedBox(height: 20),

                      _buildTeamButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),

          _buildHeader(context),

          // _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 350,

        child: Stack(
          fit: StackFit.expand,

          children: [
            if (driver.image != null &&
                driver.image!.isNotEmpty)
              Image.network(
                driver.image!,
                fit: BoxFit.cover,

                errorBuilder:
                    (context, error, stackTrace) {
                  return _buildImagePlaceholder();
                },
              )
            else
              _buildImagePlaceholder(),

            // DARK GRADIENT
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,

                  colors: [
                    Colors.transparent,
                    Color(0xCC080808),
                    Color(0xFF080808),
                  ],

                  stops: [
                    0.35,
                    0.75,
                    1.0,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFF151515),

      child: const Center(
        child: Icon(
          Icons.person,
          color: Colors.white12,
          size: 100,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: const Color(0xFF080808),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                const Spacer(),

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

                const SizedBox(
                  width: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDriverNumber() {
    final teamColor = TeamColors.getColor(team.name);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,

      children: [
        Text(
          '#${driver.number}',

          style: TextStyle(
            color: teamColor,
            fontSize: 31,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(width: 8),

        Padding(
          padding: const EdgeInsets.only(
            bottom: 5,
          ),

          child: Text(
            driver.abbreviation,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildStats() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: _buildStatCard(
  //           '—',
  //           'POINTS',
  //         ),
  //       ),

  //       const SizedBox(width: 7),

  //       Expanded(
  //         child: _buildStatCard(
  //           '—',
  //           'WINS',
  //         ),
  //       ),

  //       const SizedBox(width: 7),

  //       Expanded(
  //         child: _buildStatCard(
  //           '—',
  //           'PODIUMS',
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildStatCard(
  //   String value,
  //   String label,
  // ) {
  //   final teamColor = TeamColors.getColor(team.name);

  //   return Container(
  //     height: 70,

  //     color: const Color(0xFF111111),

  //     child: Column(
  //       mainAxisAlignment:
  //           MainAxisAlignment.center,

  //       children: [
  //         Text(
  //           value,

  //           style: TextStyle(
  //             color: teamColor,
  //             fontSize: 20,
  //             fontWeight: FontWeight.w900,
  //           ),
  //         ),

  //         const SizedBox(height: 3),

  //         Text(
  //           label,

  //           style: const TextStyle(
  //             color: Colors.white30,
  //             fontSize: 7,
  //             letterSpacing: 1.5,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildProfile() {
    final teamColor = TeamColors.getColor(team.name);

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        16,
        15,
        16,
        15,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF111111),

        border: Border(
          left: BorderSide(
            color: teamColor,
            width: 2,
          ),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            'DRIVER PROFILE',

            style: TextStyle(
              color: Colors.white30,
              fontSize: 7,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '${driver.name} races for ${team.name}. '
            'The ${driver.abbreviation} driver represents '
            '${driver.nationality} in the 2026 Formula 1 season.',

            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            'NUMBER',
            '#${driver.number}',
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _buildInfoCard(
            'TEAM',
            team.shortName,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
  ) {
    return Container(
      height: 65,

      padding: const EdgeInsets.all(12),

      color: const Color(0xFF111111),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white30,
              fontSize: 7,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamButton(
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,

      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00E5FF),

          foregroundColor: Colors.white,

          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(3),
          ),
        ),

        child: Text(
          'VIEW ${team.name.toUpperCase()}',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  // Widget _buildBottomNav() {
  //   return Positioned(
  //     left: 0,
  //     right: 0,
  //     bottom: 0,

  //     child: Container(
  //       color: const Color(0xFF080808),

  //       padding: const EdgeInsets.only(
  //         top: 8,
  //         bottom: 8,
  //       ),

  //       child: Row(
  //         mainAxisAlignment:
  //             MainAxisAlignment.spaceAround,

  //         children: [
  //           _navItem(
  //             Icons.home,
  //             'HOME',
  //           ),

  //           _navItem(
  //             Icons.article_outlined,
  //             'NEWS',
  //           ),

  //           _navItem(
  //             Icons.calendar_month,
  //             'CALENDAR',
  //           ),

  //           _navItem(
  //             Icons.groups,
  //             'TEAMS',
  //             selected: true,
  //           ),

  //           // _navItem(
  //           //   Icons.person,
  //           //   'PROFILE',
  //           // ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _navItem(
  //   IconData icon,
  //   String label, {
  //   bool selected = false,
  // }) {
  //   final color = selected
  //       ? const Color(0xFF00E5FF)
  //       : Colors.white30;

  //   return Column(
  //     mainAxisSize: MainAxisSize.min,

  //     children: [
  //       Icon(
  //         icon,
  //         color: color,
  //         size: 19,
  //       ),

  //       const SizedBox(height: 3),

  //       Text(
  //         label,
  //         style: TextStyle(
  //           color: color,
  //           fontSize: 7,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}