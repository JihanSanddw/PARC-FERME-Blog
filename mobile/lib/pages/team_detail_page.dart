import 'package:flutter/material.dart';
import 'package:mobile/constants/team_colors.dart';
import 'package:mobile/pages/driver_detail_page.dart';
import 'package:mobile/services/team_service.dart';

import '../models/team.dart';
import '../models/driver.dart';

class TeamDetailPage extends StatefulWidget {
  final Team team;

  const TeamDetailPage({super.key, required this.team});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  final TeamService teamService = TeamService();

  late Future<List<Driver>> drivers;

  @override
  void initState() {
    super.initState();

    drivers = teamService.getDriversByTeam(widget.team.idTeam);
  }

  @override

  Widget build(BuildContext context) {

  final teamColor = TeamColors.getColor(widget.team.name);
  
    return Scaffold(
      backgroundColor: const Color(0xFF080808),

      body: Column(
        children: [
          _buildHeader(context),

          Expanded(child: 
                  FutureBuilder<List<Driver>>(

                  future: drivers,

                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Failed to load drivers\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final driverList = snapshot.data ?? [];

                    return ListView(
                      padding: const EdgeInsets.all(16),

                      children: [
                        Text(
                          widget.team.shortName,
                          style: TextStyle(
                            color: teamColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          widget.team.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          widget.team.country,
                          style: const TextStyle(color: Colors.white38, fontSize: 12),
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          'DRIVERS',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 14),

                        ...driverList.map((driver) => _buildDriverCard(driver)),
                      ],
                    );
                  },
                ),
          )
        ],
      )
    );
  }

  Widget _buildHeader(BuildContext context) {
  // final teamColor = TeamColors.getColor(widget.team.name);
    return SafeArea(
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

            // Text(
            //   widget.team.name,
            //   style: TextStyle(
            //     color: teamColor,
            //     fontSize: 17,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),

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
    );
  }

  Widget _buildDriverCard(Driver driver) {
    final teamColor = TeamColors.getColor(widget.team.name);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DriverDetailPage(driver: driver, team: widget.team),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),

        decoration: BoxDecoration(
          color: const Color(0xFF111111),

          border: Border(left: BorderSide(color: teamColor, width: 4)),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Row(
            children: [
              // DRIVER NUMBER
              SizedBox(
                width: 55,

                child: Text(
                  driver.number.toString(),

                  style: TextStyle(
                    color: teamColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              // DRIVER INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      driver.name,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '${driver.abbreviation} • '
                      '${driver.nationality}',

                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right, color: teamColor.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
