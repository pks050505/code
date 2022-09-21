import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_marketing/api/community_repository.dart';
import 'package:digital_marketing/bloc/auth/auth_cubit.dart';
import 'package:digital_marketing/bloc/communityPost/commentlist/commentlist_bloc.dart';
import 'package:digital_marketing/core/imageUrl.dart';
import 'package:digital_marketing/core/utils.dart';
import 'package:digital_marketing/models/community/comment.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/user.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key, required this.postId});
  final String postId;
  static const routeName = "CommentPage";

  static Route route({required String postId}) {
    return MaterialPageRoute(
      builder: (_) => CommentPage(postId: postId),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController searchController = TextEditingController();
  User? user;

  @override
  Widget build(BuildContext context) {
    var auth = context.read<AuthCubit>().state;

    if (auth is AuthStateAuthenticated) {
      user = auth.authenticatedUser;
    }

    return Scaffold(
      appBar: const AppBarWidget(),
      body: Column(
        children: [
          ListTile(
            title: const Text('Comments 109'),
            trailing: IconButton(
              icon: const Icon(Icons.sort),
              onPressed: () {},
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black,
              foregroundImage: user?.imageUrl != null
                  ? NetworkImage(user!.imageUrl! + '${user!.data?.image1}')
                  : const NetworkImage(noProfileUrl),
            ),
            title: TextField(
              controller: searchController,
              decoration: const InputDecoration(hintText: "Add a comment..."),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Your are not authenticated.')));
                }
                if (searchController.text.isEmpty) {
                  showToast(content: "Write something...");
                  return;
                }
                Comment comment = Comment(
                  userId: user!.data!.usersId!,
                  postId: widget.postId,
                  likeCount: 0,
                  content: searchController.text,
                  profilePic: user?.data?.image1 == null
                      ? null
                      : user!.imageUrl! + '${user!.data?.image1}',
                  userName: user!.data!.name,
                );
                try {
                  var res = await context
                      .read<CommunityRepository>()
                      .addComment(comment);
                  showToast(content: res.toString());
                  searchController.clear();
                } catch (e) {
                  showToast(content: e.toString());
                }

                // context.read<FirebaseDatabase>().ref("comment").push().set(
                //       Comment(
                //         userId: user!.data!.usersId!,
                //         postId: widget.postId,
                //         likeCount: 0,
                //         content: searchController.text,
                //         profilePic: user?.data?.image1 == null
                //             ? null
                //             : user!.imageUrl! + '${user!.data?.image1}',
                //         userName: user!.data!.name,
                //       ).toJson(),
                //     );
                // .(comment.toJson());
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: FirebaseDatabase.instance
                  .ref("comment")
                  .orderByChild('postId')
                  .equalTo(widget.postId),
              itemBuilder: (context, snapshot, animation, index) {
                return CommentWidget(snapshot: snapshot);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final DataSnapshot snapshot;
  const CommentWidget({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                snapshot.child("profilePic").value as String? ?? noProfileUrl),
          ),
          title: Row(
            children: [
              Text(
                snapshot.child("username").value as String,
                style: Theme.of(context).textTheme.caption,
              ),
              Container(
                width: 30,
                child: Container(
                  height: 5,
                  width: 5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                ),
              ),
              Text(
                timeago.format(
                    Timestamp.fromMillisecondsSinceEpoch(
                      snapshot.child("timestamp").value as int? ??
                          DateTime.now().millisecondsSinceEpoch,
                    ).toDate(),
                    allowFromNow: true),
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(height: 20)
            ],
          ),
          subtitle: Text(
            snapshot.child("content").value as String,
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 14),
          ),
          trailing: PopupMenuButton(
            onSelected: (val) {
             
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(Icons.edit),
                      ),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(Icons.delete),
                      ),
                      Text('Delete'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class AppBarWidget extends StatelessWidget with PreferredSizeWidget {
  const AppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'Post',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white70,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
