import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool favorite = false;
  int cntFavorite = 0;
  bool teleg = false;
  int cntTeleg = 0;
  bool coment = false;
  int cntComent = 0;
  var storage = const FlutterSecureStorage();
  Map<int, VideoPlayerController> _videoControllers = {};
  bool _isLoading = true;

  List<dynamic> postss = [];

  @override
  void initState() {
    super.initState();
    getAllPosts();
  }

  Future<void> getAllPosts() async {
    try {
      var token = await storage.read(key: 'token');

      var respons = await http.get(
          Uri.parse('https://instagram-api.softclub.tj/Post/get-posts'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });

      if (respons.statusCode == 200) {
        setState(() {
          postss = jsonDecode(respons.body)['data'];
          _isLoading = false;
        });
        _initializeVideoControllers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong")));
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _initializeVideoControllers() {
    for (int i = 0; i < postss.length; i++) {
      if (postss[i]['images'][0].toString().split('.').last == 'mp4') {
        String videoUrl =
            "https://instagram-api.softclub.tj/images/${postss[i]['images'][0]}";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : postss.isEmpty
              ? const Center(
                  child: Text("No posts available"),
                )
              : SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      // SliverAppBar with scroll behavior
                      SliverAppBar(
                        leadingWidth: 120,
                        leading: Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: Image.asset(
                            'images/Instagram Logo.png',
                          ),
                        ),
                        actions: [
                          Container(
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.favorite_outline,
                                    size: 28,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.maps_ugc_outlined,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        floating: true,
                        snap: true,
                        backgroundColor: Colors.white,
                        // expandedHeight: 200.0,
                      ),
                      // Add a fixed widget (the amber container) as a sliver
                      SliverToBoxAdapter(
                        child: Container(
                          color: Colors.amber,
                          height: 120,
                          width: double.infinity,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(left: 8),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                  border: Border.all(
                                    color: Colors.pink,
                                    width: 3,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 12),
                            itemCount: 15,
                          ),
                        ),
                      ),
                      // Add the rest of the scrollable content (e.g., a list)
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            String mediaUrl =
                                "https://instagram-api.softclub.tj/images/${postss[index]['images'][0]}";

                            bool isVideo = postss[index]['images'][0]
                                    .toString()
                                    .split('.')
                                    .last ==
                                'mp4';

                            return Column(
                              children: [
                                Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.pink),
                                                  color: Colors.orange,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${postss[index]['userName']}",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.more_vert))
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: isVideo
                                      ? () {
                                          final controller =
                                              _videoControllers[index]!;
                                          setState(() {
                                            controller.value.isPlaying
                                                ? controller.pause()
                                                : controller.play();
                                          });
                                        }
                                      : null,
                                  child: Container(
                                    color: Colors.lightGreen,
                                    width: double.infinity,
                                    // height: 350,
                                    child: isVideo
                                        ? _videoControllers[index] != null &&
                                                _videoControllers[index]!
                                                    .value
                                                    .isInitialized
                                            ? AspectRatio(
                                                aspectRatio:
                                                    _videoControllers[index]!
                                                        .value
                                                        .aspectRatio,
                                                child: VideoPlayer(
                                                    _videoControllers[index]!),
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
                                Container(
                                  width: double.infinity,
                                  height: 130,
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      favorite = !favorite;
                                                      cntFavorite +=
                                                          favorite ? 1 : -1;
                                                    });
                                                  },
                                                  icon: favorite == false
                                                      ? Icon(
                                                          Icons.favorite_border)
                                                      : Icon(
                                                          Icons.favorite,
                                                          color: Colors.red,
                                                        )),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                      Icons.comment_outlined)),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(Icons.send)),
                                            ],
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                  Icons.turned_in_not_sharp)),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              child: const Text(
                                                "online.omuz",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text(
                                                "Орзуи барномасоз шудан доред?")
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "11 часов назад",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              child: const Text(
                                                "Показать перевод",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                          childCount: postss.length,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
