import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final List<LatLng> _traveledPath = [
    const LatLng(37.7749, -122.4194),
    const LatLng(37.7750, -122.4180),
    const LatLng(37.7760, -122.4170),
    // 他の座標を追加
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map with Path and Fog'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {},
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.7749, -122.4194),
              zoom: 14,
            ),
            // 通った座標順に直線を引く
            polylines: {
              Polyline(
                polylineId: const PolylineId('traveled_path'),
                points: _traveledPath,
                color: Colors.blue,
                width: 5,
              ),
            },
          ),
          // カスタムオーバーレイのウィジェットを配置
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.7), // 白の半透明オーバーレイ
            ),
          ),
          // 通った道の領域をクリアにする
          Positioned.fill(
            child: CustomPaint(
              painter: PathPainter(_traveledPath, MediaQuery.of(context).size),
            ),
          ),
        ],
      ),
    );
  }
}

// 通った道の領域をクリアにするためのカスタムペインター
class PathPainter extends CustomPainter {
  final List<LatLng> path;
  final Size size;

  PathPainter(this.path, this.size);

  @override
  void paint(Canvas canvas, Size size) {
    // paintオブジェクトを作成
    final paint = Paint()
      ..color = Colors.transparent
      // 透明な色で描画することで、その部分をクリアにします
      ..blendMode = BlendMode.clear
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    // Path()は描画する線のパスを表します
    // ここでパスとは、線の始点から終点までの座標のリストです
    final pathToDraw = Path();
    // 実際には地図の座標から画面上の座標への変換が必要です
    pathToDraw.moveTo(size.width * 0.5, size.height * 0.5);
    for (LatLng point in path) {
      // ダミーの座標変換
      pathToDraw.lineTo(size.width * 0.5 + (point.longitude * 10),
          size.height * 0.5 - (point.latitude * 10));
    }
    // 作成したパスを描画
    // drawPathメソッドは、(描画するパス, 描画するペイント)を引数に取ります
    canvas.drawPath(pathToDraw, paint);
  }

  @override
  // このメソッドは、ペインターが再描画する必要があるかどうかを返します
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
