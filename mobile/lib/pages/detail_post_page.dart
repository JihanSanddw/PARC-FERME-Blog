import 'package:flutter/material.dart';

import 'package:mobile/pages/edit_post_page.dart';

import '../models/post.dart';
import '../services/post_service.dart';

class DetailPostPage extends StatefulWidget {
  final int postId;

  const DetailPostPage({
    super.key,
    required this.postId,
  });

  @override
  State<DetailPostPage> createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  final PostService postService = PostService();

  late Future<Post> post;

  @override
  void initState() {
    super.initState();
    post = postService.getPostById(widget.postId);
  }

  Future<void> _deletePost() async {
    try {
      await postService.deletePost(widget.postId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF191919),
          content: Text(
            'Article deleted successfully',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF191919),
          content: Text(
            'Failed to delete article: $e',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  Future<void> _showDeleteDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111111),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          title: const Text(
            'DELETE ARTICLE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this article?',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: const Text(
                'DELETE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _deletePost();
    }
  }

  Future<void> _editPost() async {
    final currentPost = await post;

    if (!mounted) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostPage(
          post: currentPost,
        ),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        post = postService.getPostById(widget.postId);
      });
    }
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
              child: FutureBuilder<Post>(
                future: post,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00E5FF),
                        strokeWidth: 2,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Color(0xFF00E5FF),
                              size: 45,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'FAILED TO LOAD ARTICLE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text(
                        'ARTICLE NOT FOUND',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    );
                  }

                  final Post article = snapshot.data!;

                  return SingleChildScrollView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      40,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
      
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          color: const Color(0xFF00E5FF),
                          child: Text(
                            article.category.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          article.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            height: 1.1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              color: Colors.white54,
                              size: 15,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'BY ${article.author.toUpperCase()}',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        if (article.image != null &&
                            article.image!.isNotEmpty)
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(3),
                            child: Image.network(
                              article.image!,
                              width: double.infinity,
                              height: 220,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return _imagePlaceholder();
                              },
                            ),
                          )
                        else
                          _imagePlaceholder(),

                        const SizedBox(height: 22),

                        if (article.driver != null ||
                            article.team != null ||
                            article.race != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111111),
                              borderRadius:
                                  BorderRadius.circular(3),
                              border: Border.all(
                                color:
                                    const Color(0xFF242424),
                              ),
                            ),
                            child: Column(
                              children: [
                                if (article.driver != null)
                                  _InfoRow(
                                    label: 'DRIVER',
                                    value:
                                        article.driver!,
                                  ),
                                if (article.team != null)
                                  _InfoRow(
                                    label: 'TEAM',
                                    value: article.team!,
                                  ),
                                if (article.race != null)
                                  _InfoRow(
                                    label: 'RACE',
                                    value: article.race!,
                                  ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 24),

                        if (article.excerpt != null &&
                            article.excerpt!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.only(
                              left: 14,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Color(0xFF00E5FF),
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(
                              article.excerpt!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                                height: 1.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                        const SizedBox(height: 26),

                        const Text(
                          'ARTICLE',
                          style: TextStyle(
                            color: Color(0xFF00E5FF),
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          article.content,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 46,
                                child: ElevatedButton.icon(
                                  onPressed: _editPost,
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 17,
                                  ),
                                  label: const Text(
                                    'EDIT ARTICLE',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight:
                                          FontWeight.w900,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFF00E5FF),
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
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 46,
                              width: 50,
                              child: OutlinedButton(
                                onPressed: _showDeleteDialog,
                                style:
                                    OutlinedButton.styleFrom(
                                  foregroundColor:
                                      Colors.white,
                                  side: const BorderSide(
                                    color: Color(0xFF333333),
                                  ),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                      3,
                                    ),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
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

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 220,
      color: const Color(0xFF111111),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: Colors.white24,
          size: 45,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 65,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}