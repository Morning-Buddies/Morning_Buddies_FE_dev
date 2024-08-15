// import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as ui;
import 'dart:math' as math;

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all(width: 2)),
                child: const JigsawPuzzle(
                  // 퍼즐 이미지 세팅용 Container

                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Image(
                      fit: BoxFit.fitWidth,
                      image: AssetImage(
                          'assets/images/main_logo.png'), // 여기에 생성형 AI로 만든 이미지 들어가야 함
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 퍼즐 stf위젯
class JigsawPuzzle extends StatefulWidget {
  @override
  final Key? key;
  final Widget child;
  const JigsawPuzzle({this.key, required this.child}) : super(key: key);

  @override
  State<JigsawPuzzle> createState() => _JigsawPuzzleState();
}

class _JigsawPuzzleState extends State<JigsawPuzzle> {
  // GlobalKey : 특정 위젯 동적 업데이트 or 위젯 상태 직접적 제어시 사용 ex)스크롤 위치 조정, 애니메이션 트리거
  // 나중에 필요시 getX 상태적용 필요해보임
  final GlobalKey _globalKey = GlobalKey();
  ui.Image? fullImage;
  Size? size;

  List<List<BlockClass>> images = [];

  _getImageFromWidget() async {
    if (_globalKey.currentContext != null) {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
    }
  }

  // CJ🙋🏻‍♀️ 이 비동기 함수 로직 이해 안가는 부분 많아서 추가 공부 필요
  Future<void> generateJigsawImg() async {
    List<List<BlockClass>> images = [];

    fullImage ??= await _getImageFromWidget();

    int xSplitCount = 2;
    int ySplitCount = 2;
    double widthPerBlock = fullImage!.width / xSplitCount;
    double heightPerBlock = fullImage!.height / ySplitCount;

    for (var y = 0; y < ySplitCount; y++) {
      List<BlockClass> tempImages = [];
      images.add(tempImages);
      for (var x = 0; x < xSplitCount; x++) {
        int randomPosRow = math.Random().nextInt(2) % 2 == 0 ? 1 : -1;
        int randomPosCol = math.Random().nextInt(2) % 2 == 0 ? 1 : -1;

        Offset offsetCenter = Offset(widthPerBlock / 2, heightPerBlock / 2);

        // CJ🙋🏻‍♀️ 랜덤한 jigsaw in or out 포인터를 만들자는데.. 뭔말이야 (1강 10:07)
      }
    }
  }

  @override
  void initState() {
    // 이미지를 퍼즐처럼 스플릿 하기 위한 용도
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size sizeBox = MediaQuery.of(context).size;
    return SizedBox(
      height: sizeBox.width,
      child: Stack(
        children: [
          // RepainBoundary : 복잡한 레이아웃 or 그래픽 때문에 높은 렌더링 비용을 예상할 때, 성능 최적화 목적
          RepaintBoundary(
            key: _globalKey,
            // ignore: sized_box_for_whitespace
            child: Container(
              height: sizeBox.width,
              width: sizeBox.height,
              child: widget.child,
            ),
          )
        ],
      ),
    );
  }
}

class BlockClass {}
