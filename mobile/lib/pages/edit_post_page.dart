import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';

class EditPostPage extends StatefulWidget {
  final Post post;

  const EditPostPage({
    super.key,
    required this.post,
  });

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final PostService postService = PostService();

  late TextEditingController titleController;
  late TextEditingController excerptController;
  late TextEditingController contentController;
  late TextEditingController authorController;

  late int selectedCategory;
  late bool isFeatured;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final post = widget.post;

    titleController = TextEditingController(
      text: post.title,
    );

    excerptController = TextEditingController(
      text: post.excerpt ?? '',
    );

    contentController = TextEditingController(
      text: post.content,
    );

    authorController = TextEditingController(
      text: post.author,
    );

    selectedCategory = post.idCategory;
    isFeatured = post.isFeatured;
  }

  @override
  void dispose() {
    titleController.dispose();
    excerptController.dispose();
    contentController.dispose();
    authorController.dispose();

    super.dispose();
  }

  Future<void> updateArticle() async {
    if (titleController.text.trim().isEmpty ||
        contentController.text.trim().isEmpty ||
        authorController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF191919),
          content: Text(
            'Title, content, and author are required.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await postService.updatePost(
        id: widget.post.idPost,
        title: titleController.text.trim(),
        excerpt: excerptController.text.trim(),
        content: contentController.text.trim(),
        idCategory: selectedCategory,
        authorName: authorController.text.trim(),
        isFeatured: isFeatured,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF191919),
          content: Text(
            'Article updated successfully!',
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
            'Failed to update article: $error',
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

  // =========================
  // INPUT DECORATION
  // =========================

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
                padding: const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EDIT ARTICLE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Update your Formula 1 story.',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 28),

                    _buildLabel('TITLE'),

                    const SizedBox(height: 8),

                    TextField(
                      controller: titleController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      decoration: inputDecoration(
                        label: 'Title',
                        hint: 'Enter article title',
                      ),
                    ),

                    const SizedBox(height: 18),

                    _buildLabel('EXCERPT'),

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
                        hint: 'Short article description',
                      ),
                    ),

                    const SizedBox(height: 18),

                    _buildLabel('CONTENT'),

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
                        hint: 'Write your article...',
                      ),
                    ),

                    const SizedBox(height: 18),

                    _buildLabel('CATEGORY'),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<int>(
                      value: selectedCategory,
                      dropdownColor: const Color(0xFF111111),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      decoration: inputDecoration(
                        label: 'Category',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 1,
                          child: Text('Race Analysis'),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text('Driver'),
                        ),
                        DropdownMenuItem(
                          value: 3,
                          child: Text('Team'),
                        ),
                        DropdownMenuItem(
                          value: 4,
                          child: Text('Technology'),
                        ),
                        DropdownMenuItem(
                          value: 5,
                          child: Text('Paddock'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 18),

                    _buildLabel('AUTHOR'),

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

                    const SizedBox(height: 18),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111111),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: const Color(0xFF242424),
                        ),
                      ),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'FEATURED ARTICLE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        subtitle: const Text(
                          'Show this article in Trending',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                          ),
                        ),
                        activeColor: const Color(0xFF00E5FF),
                        activeTrackColor:
                            Color(0xFF00616B),
                        inactiveThumbColor: Colors.white38,
                        inactiveTrackColor: Color(0xFF242424),
                        value: isFeatured,
                        onChanged: (value) {
                          setState(() {
                            isFeatured = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            isLoading ? null : updateArticle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF00E5FF),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              const Color(0xFF00616B),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(3),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'UPDATE ARTICLE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
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
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 9,
        fontWeight: FontWeight.w900,
        letterSpacing: 1,
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
            IconButton(
              onPressed: () => Navigator.pop(context),
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
          ],
        ),
      ),
    );
  }
}