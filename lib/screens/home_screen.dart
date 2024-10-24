import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../blocs/post_bloc.dart';
import '../blocs/post_event.dart';
import '../blocs/post_state.dart';
import '../models/post_model.dart';
import '../widgets/post_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PagingController<int, Post> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController(firstPageKey: 0);
    _pagingController.addPageRequestListener((pageKey) {
      context.read<PostBloc>().add(FetchPosts());
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Blog'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Posts'),
              Tab(text: 'Author'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First tab: Post list
            BlocConsumer<PostBloc, PostState>(
              listener: (context, state) {
                if (state is PostSuccess) {
                  if (state.hasReachedMax) {
                    _pagingController.appendLastPage(state.posts);
                  } else {
                    final nextPageKey = state.posts.length;
                    _pagingController.appendPage(state.posts, nextPageKey);
                  }
                } else if (state is PostFailure) {
                  _pagingController.error = 'Failed to load posts';
                }
              },
              builder: (context, state) {
                if (state is PostLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PostFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Something went wrong'),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PostBloc>().add(FetchPosts());
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      // Grid view for larger screens (more than 600px)
                      return PagedGridView<int, Post>(
                        pagingController: _pagingController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 3 columns in the grid
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.75, // Adjust card aspect ratio
                        ),
                        builderDelegate: PagedChildBuilderDelegate<Post>(
                          itemBuilder: (context, post, index) {
                            return PostWidget(post: post);
                          },
                        ),
                      );
                    } else {
                      return PagedListView<int, Post>(
                        pagingController: _pagingController,
                        builderDelegate: PagedChildBuilderDelegate<Post>(
                          itemBuilder: (context, post, index) {
                            return PostWidget(post: post);
                          },
                        ),
                      );
                    }
                  },
                );
              },
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://avatars.githubusercontent.com/u/61640662?s=400&u=925d7f71d766b0b9b405c7551821206849f74381&v=4'), // GitHub profile picture
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Creado por Carmen Leon',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Alias: kaikrmen', // Display author's alias
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      _launchUrl('https://github.com/kaikrmen');
                    },
                    icon: const Icon(Icons.code, color: Colors.white),
                    label: const Text('Visita mi GitHub',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
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
