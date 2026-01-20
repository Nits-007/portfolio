import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

void main() {
  runApp(const MyPortfolioApp());
}

const Color kPrimaryColor = Color(0xFFD4AF37);
const Color kBackgroundColor = Color(0xFF1A1A2E);
const Color kTextColor = Color(0xFFEAEAEA);

class MyPortfolioApp extends StatelessWidget {
  const MyPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Portfolio",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme:
            GoogleFonts.cinzelDecorativeTextTheme(Theme.of(context).textTheme)
                .apply(
          bodyColor: kTextColor,
          displayColor: kPrimaryColor,
        ),
      ),
      home: const MagicCursor(child: PortfolioHomePage()),
    );
  }
}

class MagicCursor extends StatefulWidget {
  final Widget child;
  const MagicCursor({super.key, required this.child});

  @override
  State<MagicCursor> createState() => _MagicCursorState();
}

class _MagicCursorState extends State<MagicCursor> {
  Offset _cursorPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    if (!isDesktop) return widget.child;

    return MouseRegion(
      onHover: (event) => setState(() => _cursorPosition = event.position),
      child: Stack(
        children: [
          widget.child,
          Positioned(
            left: _cursorPosition.dx - 10,
            top: _cursorPosition.dy - 10,
            child: IgnorePointer(
              child: Image.asset(
                'assets/icons/wand.png',
                width: 100,
                height: 100,
                errorBuilder: (c, e, s) => const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _keys = {
    'Profile': GlobalKey(),
    'Education': GlobalKey(),
    'Experience': GlobalKey(),
    'Projects': GlobalKey(),
    'Skills': GlobalKey(),
    'Hobbies': GlobalKey(),
    'Contact': GlobalKey(),
  };

  void _scrollToSection(String section) {
    final key = _keys[section];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/bg.jpg',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: kBackgroundColor),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: isDesktop
                ? null
                : AppBar(
                    backgroundColor: kBackgroundColor.withOpacity(0.8),
                    title: Text("Nits' Portfolio",
                        style:
                            GoogleFonts.cinzelDecorative(color: kPrimaryColor)),
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: kPrimaryColor),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  ),
            drawer: !isDesktop ? _buildDrawer() : null,
            body: Column(
              children: [
                if (isDesktop) _buildDesktopHeader(),
                Expanded(
                  child: AnimationLimiter(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 20),
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 800),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(child: widget),
                          ),
                          children: [
                            _buildSection(
                              key: _keys['Profile']!,
                              title: "Profile",
                              iconPath: 'assets/icons/harry.png', //
                              iconLeft: true,
                              child: const ProfileSection(),
                            ),
                            _buildSection(
                              key: _keys['Education']!,
                              title: "Education",
                              iconPath: 'assets/icons/hogwarts.png', //
                              iconLeft: true,
                              child: const EducationSection(),
                            ),
                            _buildSection(
                              key: _keys['Experience']!,
                              title: "Experience",
                              iconPath: 'assets/icons/dumbledore.png', //
                              iconLeft: true,
                              child: const ExperienceSection(),
                            ),
                            _buildSection(
                              key: _keys['Projects']!,
                              title: "Projects",
                              iconPath: 'assets/icons/hat.png', //
                              iconLeft: true,
                              child: const ProjectSection(),
                            ),
                            _buildSection(
                              key: _keys['Skills']!,
                              title: "Tech Stack",
                              iconPath: 'assets/icons/gryffindoor.png', //
                              iconLeft: true,
                              child: const TechStackSection(),
                            ),
                            _buildSection(
                              key: _keys['Hobbies']!,
                              title: "Extra Curricular",
                              iconPath: 'assets/icons/quidditch.png', //
                              iconLeft: true,
                              child: const HobbiesSection(),
                            ),
                            _buildSection(
                              key: _keys['Contact']!,
                              title: "Contact Me",
                              iconPath: 'assets/icons/snitch.png', //
                              iconLeft: true,
                              child: const ContactSection(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      {required GlobalKey key,
      required String title,
      required String iconPath,
      required bool iconLeft,
      required Widget child}) {
    final icon = Image.asset(iconPath,
        width: 80,
        height: 80,
        errorBuilder: (c, e, s) =>
            Icon(Icons.star, size: 80, color: kPrimaryColor)); //
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 80),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                iconLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (iconLeft) ...[icon, const SizedBox(width: 15)],
              Flexible(
                child: Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cinzelDecorative(
                        fontSize: 32,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold)),
              ),
              if (!iconLeft) ...[const SizedBox(width: 15), icon],
            ],
          ),
          Container(
              height: 2,
              color: kPrimaryColor.withOpacity(0.5),
              margin: const EdgeInsets.symmetric(vertical: 20)),
          child,
        ],
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      color: kBackgroundColor.withOpacity(0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Nits' Portfolio",
              style: GoogleFonts.cinzelDecorative(
                  fontSize: 24,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold)),
          Row(
            children: _keys.keys
                .map((title) => TextButton(
                      onPressed: () => _scrollToSection(title),
                      child: Text(title,
                          style: GoogleFonts.cinzel(
                              color: kTextColor, fontSize: 16)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: kBackgroundColor,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: kPrimaryColor))),
            child: Center(
                child: Text("Menu",
                    style: GoogleFonts.cinzelDecorative(
                        fontSize: 28, color: kPrimaryColor))),
          ),
          ..._keys.keys.map((title) => ListTile(
                title: Text(title,
                    style: GoogleFonts.cinzel(color: kTextColor, fontSize: 18)),
                onTap: () {
                  Navigator.pop(context);
                  _scrollToSection(title);
                },
              )),
        ],
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  Future<void> _launchResume() async {
    final Uri url = Uri.parse('https://drive.google.com/file/d/1FoVVdVRIdSDDUezaIPUTF3FxHDjThq9C/view?usp=sharing');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return Flex(
      direction: isDesktop ? Axis.horizontal : Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: isDesktop ? 6 : 0,
          child: Column(
            crossAxisAlignment: isDesktop
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Text("Hello, I'm",
                  style:
                      GoogleFonts.cinzel(fontSize: 20, color: kPrimaryColor)),
              Text("Nishant Singh",
                  style: GoogleFonts.cinzelDecorative(
                      fontSize: isDesktop ? 60 : 40,
                      color: kTextColor,
                      fontWeight: FontWeight.bold)),
              Text("A fullstack developer",
                  style: GoogleFonts.cinzel(
                      fontSize: isDesktop ? 30 : 20,
                      color: kPrimaryColor.withOpacity(0.8))),
              const SizedBox(height: 30),
              Text(
                "I craft enchanting digital experiences, specializing in Full-Stack development, App Development, DevOps, and AI/ML Solutions. I'm passionate about building accessible and magical products for muggles and wizards alike. I am looking to apply my magical prowess in SDE / Backend / DevOps / Machine Learning roles",
                style: GoogleFonts.cinzel(fontSize: 18, height: 1.5),
                textAlign: isDesktop ? TextAlign.left : TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _launchResume,
                icon: const Icon(Icons.download_rounded, color: Colors.black),
                label: Text(
                  "Resume",
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: kPrimaryColor.withOpacity(0.5)),
                  ),
                  elevation: 10,
                  shadowColor: kPrimaryColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
        if (isDesktop) const SizedBox(width: 50),
        const SizedBox(height: 30),
        Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kPrimaryColor, width: 3),
            boxShadow: [
              BoxShadow(
                  color: kPrimaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5)
            ],
            image: const DecorationImage(
              image: AssetImage('assets/images/photo.png'),
              fit: BoxFit.cover,
              alignment: const Alignment(-0.5, 0.0),
            ),
          ),
        ),
      ],
    );
  }
}

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _InfoCard(
          title: "IIIT Kalyani",
          subtitle: "Computer Science",
          date: "2022 - 2026",
          description:
              "Final year undergrad at IIIT Kalyani having CGPA of 8.92",
        ),
      ],
    );
  }
}

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _InfoCard(
          title: "IIIT Kalyani - Govt. funded project",
          subtitle: "Machine Learning Intern",
          date: "Jan 2025 - Apr 2025",
          description:
              "Designed a Yolov5 based real time object detection model achieving 92% precision accuracy along with speech output and developed a distance tracking algorithm to track the distance between object and user",
        ),
      ],
    );
  }
}

class ProjectSection extends StatelessWidget {
  const ProjectSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProjectCategory(
            "Full Stack Development",
            [
              _ProjectData(
                  "University Management System",
                  "A complete platform to manage 20+ blocks functioning in an university along with 2 different roles for different type of users.",
                  "assets/images/uni.png",
                  ["Django REST", "Postgres", "JWT", "ORM", "React"]),
              _ProjectData(
                  "Social Media Platform",
                  "A social media platform where users can upload/edit/delete their posts along with the like/dislike functionality.",
                  "assets/images/socialmedia.png",
                  ["Flutter", "Fast API", "Postgres", "ORM", "JWT"]),
            ],
            isDesktop),
        _buildProjectCategory(
            "DevOps",
            [
              _ProjectData(
                  "Expense Tracker",
                  "Containerized backend environment using Docker, autoscaling and autohealing is done by Kubernetes with Nginx as a reverse proxy, ensuring high availabiliy.",
                  "assets/images/expense.png", [
                "Docker",
                "Kubernetes",
                "Nginx",
                "Flutter",
                "Django",
                "Redis"
              ]),
              _ProjectData(
                  "Notes App",
                  "Containerized backend using Docker Compose and Nginx served as a reverse proxy achieving scalability with health checks and auto restart policy.",
                  "assets/images/notesapp.jpg",
                  ["Docker", "Nginx", "Django REST", "Postgres", "JWT"]),
            ],
            isDesktop),
        _buildProjectCategory(
            "AI / ML",
            [
              _ProjectData(
                  "See With Me",
                  "Created a voice-controlled real-time object detection app integrating geolocation and text-to-speech for real-time navigation.",
                  "assets/images/seewithme.jpeg",
                  ["YoloV5", "Tensorflow", "Flutter", "Fast API", "Firebase"]),
            ],
            isDesktop),
      ],
    );
  }

  Widget _buildProjectCategory(
      String title, List<_ProjectData> projects, bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.cinzel(
                  fontSize: 24,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          CarouselSlider(
            options: CarouselOptions(
              height: isDesktop ? 350 : 450,
              viewportFraction: isDesktop ? 0.8 : 0.9,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              autoPlay: true,
            ),
            items: projects
                .map((project) => _ProjectCard(project: project))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final _ProjectData project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: kPrimaryColor.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Image.asset(
                  project.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.image_not_supported,
                            color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(project.title,
                                style: GoogleFonts.cinzel(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor)),
                            const SizedBox(height: 5),
                            Text(project.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.cinzel(fontSize: 12)),
                          ],
                        ),
                        Wrap(
                          spacing: 5,
                          children: project.techStack
                              .map((tech) => Chip(
                                    label: Text(tech,
                                        style: GoogleFonts.cinzel(
                                            fontSize: 10,
                                            color: kBackgroundColor)),
                                    backgroundColor: kPrimaryColor,
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectData {
  final String title, description, imageUrl;
  final List<String> techStack;
  _ProjectData(this.title, this.description, this.imageUrl, this.techStack);
}

class TechStackSection extends StatelessWidget {
  const TechStackSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> skills = [
      {"name": "C++", "icon": "assets/icons/cpp.png"},
      {"name": "Python", "icon": FontAwesomeIcons.python},
      {"name": "Dart", "icon": Icons.code},
      {"name": "Flutter", "icon": Icons.flutter_dash},
      {"name": "Django", "icon": "assets/icons/django.png"},
      {"name": "Fast API", "icon": "assets/icons/fastapi.png"},
      {"name": "Postgres", "icon": "assets/icons/postgres.png"},
      {"name": "AWS", "icon": FontAwesomeIcons.aws},
      {"name": "Docker", "icon": FontAwesomeIcons.docker},
      {"name": "Kubernetes", "icon": "assets/icons/k8s.png"},
      {"name": "Jenkins", "icon": FontAwesomeIcons.jenkins},
      {"name": "Redis", "icon": "assets/icons/redis.png"},
      {"name": "Numpy", "icon": "assets/icons/numpy.png"},
      {"name": "Pandas", "icon": "assets/icons/pandas.png"},
      {"name": "Matplotlib", "icon": "assets/icons/mtl.png"},
      {"name": "Scikit learn", "icon": "assets/icons/skl.png"},
      {"name": "Tensorflow", "icon": "assets/icons/tf.png"},
      {"name": "GitHub", "icon": FontAwesomeIcons.github},
      {"name": "Firebase", "icon": FontAwesomeIcons.fire},
      {"name": "Postman", "icon": "assets/icons/postman.png"},
    ];

    return Center(
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: skills
            .map((skill) =>
                _TechCard(name: skill['name'] as String, icon: skill['icon']))
            .toList(),
      ),
    );
  }
}

class _TechCard extends StatelessWidget {
  final String name;
  final dynamic icon;
  const _TechCard({required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kPrimaryColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: kPrimaryColor.withOpacity(0.1), blurRadius: 10)
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon is String
              ? Image.asset(
                  icon,
                  width: 40,
                  height: 40,
                )
              : Icon(icon, size: 40, color: kPrimaryColor),
          const SizedBox(height: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(fontSize: 12, color: kTextColor),
          ),
        ],
      ),
    );
  }
}

class HobbiesSection extends StatelessWidget {
  const HobbiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("When I'm not coding or casting spells...",
              style: GoogleFonts.cinzel(fontSize: 18)),
          const SizedBox(height: 30),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _HobbyCard(icon: Icons.draw_outlined, title: "Sketching"),
              _HobbyCard(icon: FontAwesomeIcons.microphone, title: "Singing"),
              _HobbyCard(icon: FontAwesomeIcons.bookOpen, title: "Reading"),
              _HobbyCard(icon: FontAwesomeIcons.tv, title: "Movies"),
            ],
          ),
        ],
      ),
    );
  }
}

class _HobbyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  const _HobbyCard({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: kPrimaryColor.withOpacity(0.2),
          child: Icon(icon, size: 40, color: kPrimaryColor),
        ),
        const SizedBox(height: 10),
        Text(title, style: GoogleFonts.cinzel(fontSize: 14)),
      ],
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) throw Exception('Could not launch $uri');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Send an owl, a raven, or an email.",
            style: GoogleFonts.cinzel(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor)),
        const SizedBox(height: 20),
        Text(
          "I'm always open to discussing new projects, creative ideas, or opportunities to be part of your visions. Feel free to reach out!",
          textAlign: TextAlign.center,
          style: GoogleFonts.cinzel(fontSize: 16),
        ),
        const SizedBox(height: 50),
        Wrap(
          spacing: 30,
          runSpacing: 30,
          alignment: WrapAlignment.center,
          children: [
            _ContactIcon(
                icon: FontAwesomeIcons.github,
                url: "https://github.com/Nits-007"),
            _ContactIcon(
                icon: FontAwesomeIcons.linkedin,
                url: "https://www.linkedin.com/in/nishant-singh-n007"),
            _ContactIcon(
                icon: FontAwesomeIcons.instagram,
                url: "https://www.instagram.com/nishant_nits17/"),
            _ContactIcon(
                icon: Icons.email, url: "mailto:nishant.sword17@gmail.com"),
          ],
        ),
        const SizedBox(height: 50),
        Text("Mischief Managed.",
            style: GoogleFonts.cinzelDecorative(
                fontSize: 14, color: kPrimaryColor.withOpacity(0.7))),
      ],
    );
  }
}

class _ContactIcon extends StatelessWidget {
  final IconData icon;
  final String url;
  const _ContactIcon({required this.icon, required this.url});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri)) throw Exception('Could not launch $uri');
      },
      icon: FaIcon(icon, size: 40, color: kPrimaryColor),
      hoverColor: kPrimaryColor.withOpacity(0.2),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title, subtitle, date, description;
  const _InfoCard(
      {required this.title,
      required this.subtitle,
      required this.date,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: kBackgroundColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border(left: BorderSide(color: kPrimaryColor, width: 4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.cinzel(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor)),
          const SizedBox(height: 5),
          Text(subtitle,
              style: GoogleFonts.cinzel(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Text(date,
              style: GoogleFonts.cinzel(
                  fontSize: 14,
                  color: kTextColor.withOpacity(0.7),
                  fontStyle: FontStyle.italic)),
          const SizedBox(height: 15),
          Text(description,
              style: GoogleFonts.cinzel(fontSize: 15, height: 1.4)),
        ],
      ),
    );
  }
}
