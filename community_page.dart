import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_marketing/api/community_repository.dart';
import 'package:digital_marketing/bloc/communityPost/commentlist/commentlist_bloc.dart';
import 'package:digital_marketing/screen/community/comment_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../bloc/communityPost/communitypage/community_page_bloc.dart';
import '../../bloc/communityPost/post/post_bloc.dart';
import '../../models/community/post.dart';

class CommunityPage extends StatefulWidget {
  static const routeName = "CommunityPage";
  const CommunityPage({super.key});
  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const CommunityPage(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: const Color(0xFF11142D),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // TextButton(
          //   child: const Text('Refresh'),
          //   onPressed: () async {
          //     // var response = await CommunityRepository().savePostToDatabase(
          //     //   Post(
          //     //     profile: "profile",
          //     //     postBy: "pk",
          //     //     postType: PostType.post,
          //     //     postTitle: "This is Post",
          //     //     videoUrl: "h",
          //     //     postImage: 'jj',
          //     //     likeCount: 0,
          //     //     postId: 'o',
          //     //   ),
          //     // );
          //     // print(response);
          //     // print(response?.length);
          //   },
          // ),
          Expanded(
            child: FirebaseAnimatedList(
              query: context.read<FirebaseDatabase>().ref("post"),
              itemBuilder: (context, snapshot, animation, index) {
                if (snapshot.child("postType").value == PostType.post.name) {
                  return PostCard(dataSnapshot: snapshot);
                }
                if (snapshot.child("postType").value == PostType.poll.name) {
                  return PollCard();
                }
                return Text('Nothing');
              },
            ),
          ),
          // Expanded(
          //   child: RefreshIndicator(
          //     onRefresh: () async => {},
          //     child: BlocBuilder<CommunityPageBloc, CommunityPageState>(
          //       builder: (context, state) {
          //         if (state is CommunityPageLoading) {
          //           return const Center(child: CupertinoActivityIndicator());
          //         }
          //         if (state is CommunityPageLoaded) {
          //           return ListView.builder(
          //             shrinkWrap: true,
          //             itemCount: state.allPosts.length,
          //             itemBuilder: (_, i) {
          //               return BlocProvider(
          //                 create: (context) => PostBloc()
          //                   ..add(
          //                     LoadPostEvent(state.allPosts[i]),
          //                   ),
          //                 child: const CommunityPostWidget(),
          //               );
          //             },
          //           );
          //         }
          //         if (state is CommunityPageError) {
          //           return Text(state.message);
          //         }
          //         return const Text("no data");
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class PollCard extends StatelessWidget {
  const PollCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('asserts/images/idpicon.png'),
            ),
            title: Text(
              'Prime video india',
              style: Theme.of(context).textTheme.headline6,
            ),
            subtitle: Text(
              timeago.format(DateTime(3000), allowFromNow: true),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          ListTile(
            title: Text(
              "This is static post type of poll",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Column(
            children: [
              PollOptionWidget(title: 'option 1', onPressed: () {}),
              PollOptionWidget(title: 'option 1', onPressed: () {}),
              PollOptionWidget(title: 'option 1', onPressed: () {}),
            ],
          ),
          ButtonBar(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.thumb_up),
                  ),
                  Text(
                    '50',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.comment),
                  ),
                  Text(
                    '51',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PollOptionWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const PollOptionWidget({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final DataSnapshot dataSnapshot;
  const PostCard({required this.dataSnapshot, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('asserts/images/idpicon.png'),
            ),
            title: Text(
              dataSnapshot.child('postBy').value as String? ??
                  "NO Post By Value "
                      'Prime video india',
              style: Theme.of(context).textTheme.headline6,
            ),
            subtitle: Text(
              timeago.format(
                  Timestamp.fromMillisecondsSinceEpoch(
                          dataSnapshot.child("timestamp").value as int? ??
                              DateTime.now().millisecondsSinceEpoch)
                      .toDate(),
                  allowFromNow: true),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          // SizedBox(height: 20),
          if ((dataSnapshot.child("postTitle").value as String?) != null)
            ListTile(
              title: Text(
                dataSnapshot.child("postTitle").value as String,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          if ((dataSnapshot.child("postImage").value as String?) != null)
            Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      dataSnapshot.child("postImage").value as String),
                ),
              ),
            ),
          ButtonBar(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      await CommunityRepository(
                              database: FirebaseDatabase.instance)
                          .fetchSdk();
                    },
                    icon: const Icon(Icons.thumb_up),
                  ),
                  Text(
                    (dataSnapshot.child("likeCount").value as int).toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, CommentPage.routeName,
                          arguments: dataSnapshot.key);
                      print("=================postId");
                      print(dataSnapshot.key);
                      BlocProvider.of<CommentlistBloc>(context)
                          .add(LoadCommentListEvent(dataSnapshot.key!));
                    },
                    icon: const Icon(Icons.comment),
                  ),
                  Text(
                    '51',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
