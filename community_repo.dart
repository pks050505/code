import 'dart:convert';

import 'package:digital_marketing/models/community/comment.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import '../models/community/post.dart';

const baseRealtimeDatabaseUrl =
    "https://idigitalpreneur-85ccd-default-rtdb.asia-southeast1.firebasedatabase.app";

class CommunityRepository {
  final FirebaseDatabase database;
  CommunityRepository({required this.database});

  savePostToDatabase(BasePost post) async {
    if (post is Post) {
      try {
        var responce = await http.post(
          Uri.parse(
              "https://idigitalpreneur-85ccd-default-rtdb.asia-southeast1.firebasedatabase.app/post.json"),
          headers: {"Accept": "application/json"},
          body: post.toJson(),
        );
        print(responce);
      } catch (e) {
        print("catch error $e");
      }
    }
  }

  Future<List<BasePost>?> fetchthePosts() async {
    try {
      // var res = await database.ref("post").get();
      // res.value;
      final response = await http.get(
        Uri.parse(
            "https://idigitalpreneur-85ccd-default-rtdb.asia-southeast1.firebasedatabase.app/post.json"),
      );
      List<BasePost> posts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((postId, postData) {
        postData['postId'] = postId;
        posts.add(BasePost.fromJson(postData));
      });

      return posts.isEmpty ? null : posts;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> addComment(Comment comment) async {
    try {
      var responce = await http.post(
        Uri.parse(
            "https://idigitalpreneur-85ccd-default-rtdb.asia-southeast1.firebasedatabase.app/comment.json"),
        headers: {"Accept": "application/json"},
        body: comment.toJson(),
      );
      return "Comment Added";
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Comment>?> fetchComments(String postId) async {
    try {
      //https://idigitalpreneur-85ccd-default-rtdb.asia-southeast1.firebasedatabase.app/
      //https://idigitalpreneur-85ccd.firebaseio.com

      final response = await http.get(
        Uri.parse(
            "https://idigitalpreneur-85ccd-default-rtdb.asia-southeast1.firebasedatabase.app/comment.json?"),
      );
      List<Comment> comments = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((id, comment) {
        comment['commentId'] = id;
        comments.add(Comment.fromJson(comment));
      });

      return comments.isEmpty ? null : comments;
    } catch (e) {
      return null;
    }
  }

  Future<String> fetchSdk() async {
    try {
      print('abc---------');
      var ref = await FirebaseDatabase.instance.ref("post").get();

      // var ref = await FirebaseDatabase.instanceFor(
      //         app: app,
      //         databaseURL: "https://idigitalpreneur-85ccd.firebaseio.com")
      //     .ref('post')
      //     .get();
      print(ref.value);
    } catch (e) {
      print("from catch");
    }
    return "return a";
  }
}
