import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_here/utils/debug.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/material.dart' as material;

class ProductArScreen extends StatefulWidget {
  final String title;
  final String modelPathFromAppDir;

  const ProductArScreen({
    required this.title,
    required this.modelPathFromAppDir,
  });

  @override
  State<ProductArScreen> createState() => _ProductArScreenState();
}

class _ProductArScreenState extends State<ProductArScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  ARNode? localObjectNode;
  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  double scale = 100;

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.title}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontal,
            ),
            Positioned(
                bottom: 80,
                left: 20,
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(14),
                      ),
                      onPressed: () {
                        this.localObjectNode?.position =
                            this.localObjectNode!.position +
                                Vector3(0.0, 0.01, 0.0);
                      },
                      child: Icon(Icons.arrow_upward),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(14),
                      ),
                      onPressed: () {
                        this.localObjectNode?.position =
                            this.localObjectNode!.position +
                                Vector3(0.0, -0.01, 0.0);
                      },
                      child: Icon(Icons.arrow_downward),
                    ),
                  ],
                )),
            Positioned(
              bottom: 80,
              right: 20,
              child: Column(
                children: [
                  Text(
                    '${scale} %',
                    style: TextStyle(
                      fontSize: 12,
                      color: (scale != 100)
                          ? material.Colors.red
                          : material.Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(12),
                    ),
                    onPressed: () {
                      this.localObjectNode?.scale =
                          Vector3(scale / 100.0, scale / 100.0, scale / 100.0);
                      setState(() {
                        scale += 1;
                      });
                    },
                    child: Text('+', style: TextStyle(fontSize: 20)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(12),
                    ),
                    onPressed: () {
                      this.localObjectNode?.scale =
                          Vector3(scale / 100.0, scale / 100.0, scale / 100.0);
                      setState(() {
                        scale -= 1;
                      });
                    },
                    child: Text('-', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "Images/triangle.png",
      showWorldOrigin: false,
      handlePans: true,
      handleRotation: true,
    );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;

    this.arObjectManager!.onPanStart = onPanStarted;
    this.arObjectManager!.onPanChange = onPanChanged;
    this.arObjectManager!.onPanEnd = onPanEnded;

    this.arObjectManager!.onRotationStart = onRotationStarted;
    this.arObjectManager!.onRotationChange = onRotationChanged;
    this.arObjectManager!.onRotationEnd = onRotationEnded;
  }

  void updateLocalObjectNodeReference(String nodeName) {
    this.localObjectNode =
        this.nodes.firstWhere((element) => element.name == nodeName);
  }

  onPanStarted(String nodeName) {
    updateLocalObjectNodeReference(nodeName);
  }

  onPanChanged(String nodeName) {
    // debug(context, "Continued panning node " + nodeName);
    // updateLocalObjectNodeReference(nodeName);
  }

  onPanEnded(String nodeName, Matrix4 newTransform) {}

  onRotationStarted(String nodeName) {
    updateLocalObjectNodeReference(nodeName);
  }

  onRotationChanged(String nodeName) {}

  onRotationEnded(String nodeName, Matrix4 newTransform) {}

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        this.anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
            type: NodeType.fileSystemAppFolderGLB,
            uri: '${widget.modelPathFromAppDir}',
            scale: Vector3(scale / 100.0, scale / 100.0, scale / 100.0),
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0));
        bool? didAddNodeToAnchor = await this
            .arObjectManager!
            .addNode(newNode, planeAnchor: newAnchor);
        this.localObjectNode = (didAddNodeToAnchor!) ? newNode : null;
        if (didAddNodeToAnchor) {
          this.nodes.add(newNode);
        } else {
          this.arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        this.arSessionManager!.onError("Adding Anchor failed");
      }
      /*
      // To add a node to the tapped position without creating an anchor, use the following code (Please mind: the function onRemoveEverything has to be adapted accordingly!):
      var newNode = ARNode(
          type: NodeType.localGLTF2,
          uri: "Models/Chicken_01/Chicken_01.gltf",
          scale: Vector3(0.2, 0.2, 0.2),
          transformation: singleHitTestResult.worldTransform);
      bool didAddWebNode = await this.arObjectManager.addNode(newNode);
      if (didAddWebNode) {
        this.nodes.add(newNode);
      }*/
    }
  }
}
