import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/api.dart';
import 'package:fluttertube/models/video.dart';

class VideosBloc implements BlocBase {


  Api api;
  List<Video> videos;

  final StreamController<List<Video>> _videoController = StreamController<List<Video>>();
  Stream get outVideos => _videoController.stream;


  final StreamController<String> _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink;



  VideosBloc() {
    api = Api();


    _searchController.stream.listen(_search);
  }


  void _search(String search) async{


    if (search != null){
      _videoController.sink.add([]);
      videos = await api.search(search);
    }else{

      videos += await api.nextPage();

    }


    print(videos);

    _videoController.sink.add(videos);


  }

  @override
  void dispose() {
    _videoController.close();
    _searchController.close();
  }
}
