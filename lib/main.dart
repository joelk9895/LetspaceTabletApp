// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: VideoPlayerWidget(),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller = VideoPlayerController.network('');

  int _currentIndex = 0;
  final List<String> _videoUrls = [
    'https://rr4---sn-npoe7ndl.googlevideo.com/videoplayback?expire=1708440121&ei=2WXUZdCoGqf6mLAPv8-X4Ac&ip=188.241.178.19&id=o-AMh2r0_ROinctpcHzoSnc8s7qO59DNf0pQmafG8Qyq5A&itag=401&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ%3D%3D&spc=UWF9f5OlFbC5Xtfk1PrRLMDNVjUPm1yGwUdUnotXrk0xnj8&vprv=1&svpuc=1&mime=video%2Fmp4&gir=yes&clen=34643295&dur=30.000&lmt=1699047509264508&keepalive=yes&fexp=24007246&c=ANDROID&txp=4532434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cxpc%2Cspc%2Cvprv%2Csvpuc%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&sig=AJfQdSswRAIgIPijZcc6iLdzTFEB6mYjBbOOqfh7n-znx-J7OCEXJiACIHCviTPuZE7GJ8-QirXCJa_mEqdtyCqbExw9UC_cxjCk&redirect_counter=1&cm2rm=sn-q0cel7z&req_id=cb5080fe04bda3ee&cms_redirect=yes&mh=Jv&mip=223.190.222.204&mm=34&mn=sn-npoe7ndl&ms=ltu&mt=1708418190&mv=m&mvi=4&pl=21&lsparams=mh,mip,mm,mn,ms,mv,mvi,pl&lsig=APTiJQcwRgIhAIs9QKsRjYLkWIIi1jiH17FDYgILF9LY0vx2JRswKj3jAiEA9Aue6zn81q_gG8Wu52wmWCxjvAdGJ9FPR_F6p-Z31ac%3D',
    'https://rr5---sn-ci5gup-jjwe.googlevideo.com/videoplayback?expire=1708430305&ei=gT_UZY6PBcvBp-oPurOKiAI&ip=45.133.172.235&id=o-ACD-17D3OdU_X9Q2_aAORID9nXghrPhq3nqZ3m4OErRl&itag=248&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ%3D%3D&spc=UWF9f4ch8FUZhytpnow78JkaBMeBSXVP-cyxLuEgX9lT5MI&vprv=1&svpuc=1&mime=video%2Fwebm&gir=yes&clen=11053342&dur=90.000&lmt=1707861265833168&keepalive=yes&fexp=24007246&c=ANDROID&txp=4535434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cxpc%2Cspc%2Cvprv%2Csvpuc%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&sig=AJfQdSswRgIhAKr4sj_hZRSKNR0V8JUODGw61Kw5uh9-h4EnostYDBa_AiEAgUIW9CoAz9J0ydm6LybILecw7SAXIMgL2qSjf9CmZgQ%3D&redirect_counter=1&rm=sn-aigez67z&req_id=e81e1def4753a3ee&cms_redirect=yes&cmsv=e&ipbypass=yes&mh=4n&mip=223.190.222.204&mm=31&mn=sn-ci5gup-jjwe&ms=au&mt=1708418016&mv=u&mvi=5&pl=21&lsparams=ipbypass,mh,mip,mm,mn,ms,mv,mvi,pl&lsig=APTiJQcwRgIhAOfFhOUwFlUfW0V8dwPVkgOe0F8QOMuZaotDbCFEitNWAiEAvelH1D5jY_luFCNrVxAfJKgNKwQnBPckuwecntDipmo%3D',
  ];
  final List<String> _imageUrls = [
    'https://pbs.twimg.com/media/FlCiTnGXgAEKctG.jpg',
    'https://pbs.twimg.com/media/FlCiTnGXgAEKctG.jpg'
  ];

  @override
  void initState() {
    super.initState();
    _playMedia(_currentIndex);
  }

  void _playMedia(int index) {
    if (index < _videoUrls.length + _imageUrls.length) {
      if (index % 2 == 0) {
        _playVideo(_videoUrls[index ~/ 2]);
      } else {
        _showImage(_imageUrls[(index - _videoUrls.length) ~/ 2]);
      }
    } else {
      // You've reached the end of the media list
      print('All media played');
    }
  }

  void _playVideo(String videoUrl) {
    if (_controller.value.isInitialized) {
      _controller.dispose();
    }
    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
        _controller.addListener(() {
          if (_controller.value.position >= _controller.value.duration) {
            _playNextMedia();
          }
        });
        _controller.setLooping(false);
        _controller.play();
      });
  }

  void _showImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.popUntil(
                context, ModalRoute.withName(Navigator.defaultRouteName));
            _playNextMedia();
          });
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _playNextMedia() {
    setState(() {
      _currentIndex++;
    });
    if (_currentIndex < _videoUrls.length + _imageUrls.length) {
      _playMedia(_currentIndex);
    } else {
      _currentIndex = 0; // Reset to the first media
      _playMedia(_currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                VideoPlayer(_controller),
              ],
            ),
          )
        : const CircularProgressIndicator();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
