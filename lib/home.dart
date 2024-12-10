import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:instalife/Users.dart';
import 'package:instalife/chat.dart';
import 'package:http/http.dart' as http;

import 'package:video_player/video_player.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final TextEditingController _controllerComent = TextEditingController();
  var pageNumber = 1;
  bool _showBigHeart = true;

  Map<int, VideoPlayerController> _videoControllers = {};
  var storage = FlutterSecureStorage();
  bool isTextEmpty = false;
  bool _isLoading = true;

  final ScrollController _scrolcontroller = ScrollController();

  List<dynamic> post = [];
  List<dynamic> stories = [];
  @override
  void initState() {
    super.initState();
    getPost(pageNumber);
    getAllStories();
    getMyStories();

    _scrolcontroller.addListener(lisenToScrolMomennts);
    _controllerComent.addListener(() {
      setState(() {
        isTextEmpty = _controllerComent.text.isEmpty;
      });
    });
  }

  void lisenToScrolMomennts() {
    if (_scrolcontroller.offset == _scrolcontroller.position.maxScrollExtent) {
      setState(() {
        pageNumber++;
        getPost(pageNumber);
      });
    }
  }

  Future postLike(int cnt) async {
    try {
      var token = await storage.read(key: "token");

      var response = await http.post(
          Uri.parse(
              "https://instagram-api.softclub.tj/Post/like-post?postId=${cnt}"),
          headers: <String, String>{
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
      if (response.statusCode == 200) {
        print("Saksesfule");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllStories() async {
    try {
      var token = await storage.read(key: "token");
      var responses = await http.get(
        Uri.parse("https://instagram-api.softclub.tj/Story/get-stories"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (responses.statusCode == 200) {
        setState(() {
          stories = jsonDecode(responses.body);
        });
        _initializeVideoControllers();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Ошибка получения stories")));
        throw Exception();
      }
    } catch (e) {}
  }

  var myStories = {};
  Future<void> getMyStories() async {
    try {
      var token = await storage.read(key: "token");
      var responses = await http.get(
        Uri.parse("https://instagram-api.softclub.tj/Story/get-my-stories"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (responses.statusCode == 200) {
        setState(() {
          myStories = jsonDecode(responses.body)['data'];
        });
        _initializeVideoControllers();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Ошибка получения stories")));
        throw Exception();
      }
    } catch (e) {}
  }

  Future<void> sendComentToPost(int postiD) async {
    try {
      var token = await storage.read(key: "token");
      var respons = await http.post(
          Uri.parse("https://instagram-api.softclub.tj/Post/add-comment"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(
              {"comment": _controllerComent.text, "postId": postiD}));
      if (respons.statusCode == 200) {
        _controllerComent.clear();
        print("coment raftttt");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Ошибка отправки коментария")));
        throw Exception();
      }
    } catch (e) {
      print('$e');
    }
  }

  Future<void> deleteComent() async {
    try {
      var response = await http.delete(
        Uri.parse("https://instagram-api.softclub.tj/Post/delete-comment"),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
      }
    } catch (e) {}
  }

  Future<void> getPost(pageNumber) async {
    try {
      var token = await storage.read(key: "token");
      var respons = await http.get(
        Uri.parse(
            "https://instagram-api.softclub.tj/Post/get-posts?pageNumber=${pageNumber}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (respons.statusCode == 200) {
        setState(() {
          for (var element in jsonDecode(respons.body)['data']) {
            post.add(element);
          }

          _isLoading = false;
        });
        _initializeVideoControllers();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Ошибка получения постов")));
        throw Exception();
      }
    } catch (e) {
      print('$e');
    }
  }

  void _initializeVideoControllers() {
    for (int i = 0; i < post.length; i++) {
      if (post[i]['images'][0].toString().split('.').last == 'mp4') {
        String videoUrl =
            "https://instagram-api.softclub.tj/images/${post[i]['images'][0]}";

        final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
          ..initialize().then((_) {
            setState(() {}); // Refresh UI after initialization
          });

        _videoControllers[i] = controller;
      }
    }
  }

  @override
  void dispose() {
    // Dispose all video controllers
    _videoControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  bool sdda = false;
  bool favorite = false;
  num cntFavorite = 0;
  bool teleg = false;
  num cntTeleg = 0;
  bool coment = false;
  num cntComent = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 140,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Image.asset("images/Instagram Logo.png"),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Chat()));
                },
                icon: Icon(
                  Icons.maps_ugc_sharp,
                  size: 30,
                ),
              ),
            ],
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : post.isEmpty
              ? const Center(
                  child: Text("No posts available"),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    controller: _scrolcontroller,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            height: 120,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => MakeStories(
                                                      ImageUrl:
                                                          "https://instagram-api.softclub.tj/images/${stories[index]["stories"][0]["fileName"]}")));
                                        },
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      "https://instagram-api.softclub.tj/images/${stories[index]["userImage"]}"),
                                                  fit: BoxFit.cover),
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 255, 98, 0),
                                                  width: 3)),
                                        ),
                                      ),
                                      Text(
                                        "${stories[index]["userName"]}",
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 15,
                                  );
                                },
                                itemCount: stories.length),
                          ),
                          Container(
                            width: double.infinity,
                            height: 615,
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  String mediaUrl =
                                      "https://instagram-api.softclub.tj/images/${post[index]['images'][0]}";

                                  bool isVideo = post[index]['images'][0]
                                          .toString()
                                          .split('.')
                                          .last ==
                                      'mp4';
                                  return Container(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.only(left: 10, top: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.red,
                                                    ),
                                                    child: ClipOval(
                                                      child: post[index][
                                                                      "userImage"] ==
                                                                  null ||
                                                              post[index][
                                                                      "userImage"] ==
                                                                  ''
                                                          ? Image.asset(
                                                              "images/photo_2023-01-11_21-33-28.jpg",
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.network(
                                                              "https://instagram-api.softclub.tj/images/${post[index]["userImage"]}",
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      User(
                                                                        Userid: post[index]
                                                                            [
                                                                            "userId"],
                                                                        name: post[index]
                                                                            [
                                                                            "userName"],
                                                                      )));
                                                    },
                                                    child: Text(
                                                      " ${post[index]['userName']}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        return Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 20),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Container(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                70,
                                                                            height:
                                                                                70,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                  width: 0.5,
                                                                                ),
                                                                                shape: BoxShape.circle),
                                                                            child:
                                                                                Icon(
                                                                              Icons.turned_in_not,
                                                                              size: 40,
                                                                              weight: 0.1,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "Save",
                                                                            style:
                                                                                TextStyle(fontSize: 14),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                70,
                                                                            height:
                                                                                70,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                  width: 0.5,
                                                                                ),
                                                                                shape: BoxShape.circle),
                                                                            child:
                                                                                Icon(
                                                                              Icons.autorenew,
                                                                              size: 40,
                                                                              weight: 0.1,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "Remics",
                                                                            style:
                                                                                TextStyle(fontSize: 14),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                70,
                                                                            height:
                                                                                70,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                  width: 0.5,
                                                                                ),
                                                                                shape: BoxShape.circle),
                                                                            child:
                                                                                Icon(
                                                                              Icons.qr_code_scanner_outlined,
                                                                              size: 40,
                                                                              weight: 0.1,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "QR-code",
                                                                            style:
                                                                                TextStyle(fontSize: 14),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 1,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 1,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                                icon: Icon(
                                                  Icons.more_vert_rounded,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Stack(
                                          alignment: Alignment
                                              .center, // Барои марказӣ кардани дил
                                          children: [
                                            GestureDetector(
                                              onDoubleTap: () {
                                                setState(() {
                                                  postLike(
                                                      post[index]["postId"]);
                                                  favorite = !favorite;
                                                  cntFavorite +=
                                                      favorite ? 1 : -1;
                                                  _showBigHeart = true;
                                                });
                                              },
                                              onTap: isVideo
                                                  ? () {
                                                      final controller =
                                                          _videoControllers[
                                                              index]!;
                                                      setState(() {
                                                        controller
                                                                .value.isPlaying
                                                            ? controller.pause()
                                                            : controller.play();
                                                      });
                                                    }
                                                  : null,
                                              child: Container(
                                                color: Colors.lightGreen,
                                                width: double.infinity,
                                                child: isVideo
                                                    ? _videoControllers[
                                                                    index] !=
                                                                null &&
                                                            _videoControllers[
                                                                    index]!
                                                                .value
                                                                .isInitialized
                                                        ? AspectRatio(
                                                            aspectRatio:
                                                                _videoControllers[
                                                                        index]!
                                                                    .value
                                                                    .aspectRatio,
                                                            child: VideoPlayer(
                                                                _videoControllers[
                                                                    index]!),
                                                          )
                                                        : const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          )
                                                    : Image.network(
                                                        mediaUrl,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            setState(
                                                              () {
                                                                postLike(post[
                                                                        index]
                                                                    ["postId"]);
                                                              },
                                                            );
                                                          },
                                                          icon: post[index][
                                                                      "postId"] ==
                                                                  false
                                                              ? Icon(
                                                                  Icons
                                                                      .favorite_border_sharp,
                                                                )
                                                              : Icon(
                                                                  Icons
                                                                      .favorite_sharp,
                                                                ),
                                                        ),
                                                        Text(
                                                          '${cntFavorite + post[index]['postLikeCount']}',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              setState(
                                                                () {
                                                                  showcoment(
                                                                      context,
                                                                      post[index]
                                                                          [
                                                                          "comments"],
                                                                      post[index]
                                                                          [
                                                                          'postId']);
                                                                },
                                                              );
                                                            },
                                                            icon: Icon(
                                                                Icons.comment)),
                                                        Text(
                                                          '${cntComent + post[index]["commentCount"]}',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            setState(
                                                              () {
                                                                showModalBottomSheet(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          Container(
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          child:
                                                                              Text("Search"),
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              GridView.count(
                                                                            crossAxisCount:
                                                                                3,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          icon: Icon(Icons
                                                              .telegram_outlined),
                                                        ),
                                                        Text(
                                                          '${cntTeleg + post[index]["postView"]}',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {});
                                                },
                                                icon: Icon(Icons.turned_in_not),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            textAlign: TextAlign.left,
                                            "${post[index]["title"]}",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 0,
                                  );
                                },
                                itemCount: post.length),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Future<dynamic> showcoment(BuildContext context, List comment, postiD) {
    return showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "COMMENTS",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            comment.isEmpty
                ? Center(
                    child: Text(
                      "No comment",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onDoubleTap: () {
                            setState(() {
                              sdda = !sdda;
                              getPost(pageNumber);
                            });
                          },
                          child: GestureDetector(
                            onLongPress: () {
                              comment[index]["userId"] == myStories["userId"]
                                  ? showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                              content: Container(
                                            width: 200,
                                            height: 100,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Добавить в историю",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Icon(Icons
                                                        .add_circle_outline_outlined)
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Создат ветку",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Icon(Icons
                                                        .alternate_email_outlined)
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      deleteComent();
                                                    });
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Удалить",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red),
                                                      ),
                                                      Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )))
                                  : showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                              content: Container(
                                            width: 200,
                                            height: 103,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Добавить в историю",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .add_circle_outline_rounded,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Пожаловаться",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.red),
                                                    ),
                                                    Icon(
                                                      Icons.error_outline,
                                                      color: Colors.red,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Зоброкировать",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.red),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .not_interested_rounded,
                                                      color: Colors.red,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          )));
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child:
                                              comment[index]['userImage'] == ''
                                                  ? Image.asset(
                                                      "images/3135715.png")
                                                  : Image.network(
                                                      "https://instagram-api.softclub.tj/images/${comment[index]['userImage']}",
                                                      fit: BoxFit.cover,
                                                    ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 14,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  "${comment[index]['userName']}"),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${comment[index]['dateCommented'].toString().split("T")[0]}",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color.fromARGB(
                                                        255, 123, 123, 123)),
                                              ),
                                            ],
                                          ),
                                          Text("${comment[index]['comment']}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            sdda = !sdda;
                                            getPost(pageNumber);
                                          });
                                        },
                                        child: Icon(
                                          sdda == false
                                              ? Icons.favorite_border
                                              : Icons.favorite,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                      Text(
                                        "1",
                                        style: TextStyle(fontSize: 10),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 15,
                        );
                      },
                      itemCount: comment.length,
                    ),
                  ),
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: ClipRRect(
                          child: Image.asset("images/3135715.png"),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller: _controllerComent,
                          decoration: InputDecoration(
                            hintText: "Write a comment",
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_controllerComent.text.isNotEmpty) {
                            print("Text: ${_controllerComent.text}");
                            setState(() {
                              sendComentToPost(postiD);
                            });
                          }
                        },
                        icon: !_controllerComent.text.isEmpty
                            ? Icon(Icons.telegram_outlined)
                            : Icon(Icons.gif),
                        iconSize: 35.0,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MakeStories extends StatefulWidget {
  final String ImageUrl;
  const MakeStories({super.key, required this.ImageUrl});

  @override
  State<MakeStories> createState() => _MakeStoriesState();
}

class _MakeStoriesState extends State<MakeStories> {
  bool ssfav = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(child: Image.network(widget.ImageUrl)),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: Colors.black,
        child: Row(
          children: [
            Container(
              width: 250,
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  prefixIcon: Icon(
                    Icons.comment,
                    color: Colors.white,
                  ),
                  filled: true,
                  fillColor: Colors.black,
                  hintText: "Write a comment",
                  hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 171, 171, 171)),
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.telegram,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          ssfav = !ssfav;
                        });
                      },
                      icon: ssfav == false
                          ? Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
