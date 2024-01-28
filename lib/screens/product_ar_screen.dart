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
import 'package:demo_space/utils/debug.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ProductArScreen extends StatefulWidget {
  final String title;
  final String modelUrl;

  const ProductArScreen({
    required this.title,
    required this.modelUrl,
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

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
      ),
      body: Container(
        child: Stack(
          children: [
            ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontal,
            )
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
      showWorldOrigin: true,
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

  Future<void> onButtonPressed() async {
    // show an alert saying hello
    if (localObjectNode != null) {
      arObjectManager!.removeNode(localObjectNode!);
      localObjectNode = null;
    } else {
      var newNode = ARNode(
        type: NodeType.webGLB,
        uri: this.widget.modelUrl,
        scale: Vector3(0.2, 0.2, 0.2),
        position: Vector3(0.0, 0.0, 0.0),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0),
      );
      bool? didAddLocalNode = await this.arObjectManager!.addNode(newNode);
      this.localObjectNode = (didAddLocalNode!) ? newNode : null;
    }
  }

  void updateLocalObjectNodeReference(String nodeName) {
    this.localObjectNode =
        this.nodes.firstWhere((element) => element.name == nodeName);
  }

  onPanStarted(String nodeName) {
    debug(context, "Started panning node " + nodeName);
    updateLocalObjectNodeReference(nodeName);
  }

  onPanChanged(String nodeName) {
    debug(context, "Continued panning node " + nodeName);
    // updateLocalObjectNodeReference(nodeName);
  }

  onPanEnded(String nodeName, Matrix4 newTransform) {
    debug(context, "Ended panning node " + nodeName);
  }

  onRotationStarted(String nodeName) {
    debug(context, "Started rotating node " + nodeName);
    updateLocalObjectNodeReference(nodeName);
  }

  onRotationChanged(String nodeName) {
    debug(context, "Continued rotating node " + nodeName);
  }

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    debug(context, "Ended rotating node " + nodeName);
  }

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
            type: NodeType.webGLB,
            uri:
                'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/Duck/glTF-Binary/Duck.glb',
            scale: Vector3(1, 1, 1),
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
