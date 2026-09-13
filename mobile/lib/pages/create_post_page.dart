import 'package:flutter/material.dart';

import '../services/post_service.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final PostService postService = PostService();

  final titleController = TextEditingController();
  final excerptController = TextEditingController();
  final contentController = TextEditingController();
  final authorController = TextEditingController();
  

  bool isLoading = false;
  bool isFeatured = false;

  int selectedCategory = 1;


  @override
  void dispose() {
    titleController.dispose();
    excerptController.dispose();
    contentController.dispose();
    authorController.dispose();

    super.dispose();
  }

  Future<void> createArticle() async {
    if (titleController.text.trim().isEmpty ||
        contentController.text.trim().isEmpty ||
        authorController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF191919),
          content: Text(
            'Title, content and authro are required.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await postService.createPost(
        title: titleController.text.trim(),
        excerpt: excerptController.text.trim(),
        content: contentController.text.trim(),
        authorName: authorController.text.trim(),
        idCategory: selectedCategory,
        isFeatured: isFeatured,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF191919),
          content: Text(
            'Article created successfully!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF191919),
          content: Text(
            'Failed to create article: $error',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  InputDecoration inputDecoration({
    required String label,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,

      labelStyle: const TextStyle(
        color: Colors.white54,
        fontSize: 12,
      ),

      hintStyle: const TextStyle(
        color: Colors.white24,
        fontSize: 12,
      ),

      filled: true,
      fillColor: const Color(0xFF111111),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(
          color: Color(0xFF242424),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(
          color: Color(0xFF242424),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(
          color: Color(0xFF00E5FF),
          width: 1.2,
        ),
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
                physics:
                    const AlwaysScrollableScrollPhysics(),

                padding: const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  30,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(
                      'NEW ARTICLE',
                      style: TextStyle(
                        color: Color(0xFF00E5FF),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'CREATE ARTICLE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'ARTICLE TITLE',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: titleController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      decoration: inputDecoration(
                        label: 'Title',
                        hint:
                            'Enter your article title',
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'EXCERPT',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: excerptController,
                      maxLines: 3,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                      decoration: inputDecoration(
                        label: 'Excerpt',
                        hint:
                            'Short description of the article',
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'CONTENT',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: contentController,
                      maxLines: 10,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.5,
                      ),
                      decoration: inputDecoration(
                        label: 'Content',
                        hint:
                            'Write your article here...',
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'CATEGORY',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<int>(
                      value: selectedCategory,

                      dropdownColor:
                          const Color(0xFF191919),

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),

                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white54,
                      ),

                      decoration: inputDecoration(
                        label: 'Category',
                      ),

                      items: const [
                        DropdownMenuItem(
                          value: 1,
                          child: Text(
                            'Race Analysis',
                          ),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text(
                            'Driver',
                          ),
                        ),
                        DropdownMenuItem(
                          value: 3,
                          child: Text(
                            'Team',
                          ),
                        ),
                        DropdownMenuItem(
                          value: 4,
                          child: Text(
                            'Technology',
                          ),
                        ),
                        DropdownMenuItem(
                          value: 5,
                          child: Text(
                            'Paddock',
                          ),
                        ),
                      ],

                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCategory =
                                value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'AUTHOR',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: authorController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      decoration: inputDecoration(
                        label: 'Author',
                        hint: 'Enter author name',
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF111111),

                        borderRadius:
                            BorderRadius.circular(3),

                        border: Border.all(
                          color:
                              const Color(0xFF242424),
                        ),
                      ),

                      child: SwitchListTile(
                        contentPadding:
                            EdgeInsets.zero,

                        title: const Text(
                          'Featured Article',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        subtitle: const Text(
                          'Show this article in Trending',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                          ),
                        ),

                        value: isFeatured,

                        activeColor:
                            const Color(0xFF00E5FF),

                        activeTrackColor:
                            const Color(0xFF5C0808),

                        inactiveThumbColor:
                            const Color(0xFF777777),

                        inactiveTrackColor:
                            const Color(0xFF292929),

                        onChanged: (value) {
                          setState(() {
                            isFeatured = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : createArticle,

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF00E5FF,
                          ),

                          disabledBackgroundColor:
                              const Color(
                            0xFF4A4A4A,
                          ),

                          foregroundColor:
                              Colors.white,

                          elevation: 0,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              3,
                            ),
                          ),
                        ),

                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  Icon(
                                    Icons
                                        .publish_outlined,
                                    size: 18,
                                  ),

                                  SizedBox(width: 8),

                                  Text(
                                    'PUBLISH ARTICLE',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight:
                                          FontWeight
                                              .w900,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
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
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 64,

      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),

        child: Row(
          children: [
            // BACK
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },

              padding: EdgeInsets.zero,

              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 21,
              ),
            ),

            const SizedBox(width: 4),

            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'PARC ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),

                  TextSpan(
                    text: 'FERMÉ',
                    style: TextStyle(
                      color:
                          Color(0xFF00E5FF),
                      fontSize: 20,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}