import 'dart:ui';
import 'package:boats_challenge/widgets/custom_curve.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import 'package:boats_challenge/models/boats.dart';
import 'package:flutter/material.dart';

class BoatHomePage extends StatefulWidget {
  @override
  _BoatHomePageState createState() => _BoatHomePageState();
}

class _BoatHomePageState extends State<BoatHomePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;
  late ScrollController _scrollController;
  late CurvedAnimation _curvedAnimation;

  bool isDetailClosed = true;

  @override
  void initState() {
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {});
    });

    _scrollController = ScrollController();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {});
          });

    //_curvedAnimation Curve also is modified in _onTap method
    _curvedAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutBack);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boatList = getDummyListBo();
    return Material(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 120),
            height: MediaQuery.of(context).size.height,
            child: PageView.builder(
                controller: _pageController,
                itemCount: 5,
                itemBuilder: (context, index) {
                  double? page = 0;
                  if (!_pageController.position.hasContentDimensions) {
                    page = 0.0;
                  } else {
                    page = _pageController.page;
                  }
                  page = page ?? 0;
                  final double aux = page - index;
                  final double? x =
                      lerpDouble(0, -200, (_curvedAnimation.value));
                  final double? y =
                      lerpDouble(0, 100, (_curvedAnimation.value));
                  final double? rotationZ =
                      lerpDouble(0, -90, (_curvedAnimation.value));

                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 10),
                      // accelerate vanish
                      opacity: aux > 0
                          ? (1 - aux * 2.5).clamp(0, 1)
                          : (1 + aux * 2.5).clamp(0, 1),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: isDetailClosed
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.end,
                          crossAxisAlignment: isDetailClosed
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.005)
                                ..translate(x, y ?? 0.0)
                                ..rotateZ(vector.radians(rotationZ ?? 0.0)),
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.6,
                              transformAlignment: Alignment.topCenter,
                              child: Image.asset(boatList[index].imgUrl),
                            ),
                            isDetailClosed
                                ? buildSmallDescription(boatList, index)
                                : buildFullDescription(
                                    boatList, index, _curvedAnimation),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
          _buildAppBar(),
          isDetailClosed == false ? _buildCloseButtom() : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildCloseButtom() {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: isDetailClosed ? 0 : 1,
      child: SafeArea(
        child: CupertinoButton(
          child: Icon(
            Icons.cancel,
            color: Colors.grey,
          ),
          onPressed: () {
            _onTap();
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 100),
      opacity: isDetailClosed ? 1 : 0,
      child: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Boats',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.find_replace,
                size: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSmallDescription(List<Boats> boatList, int index) {
    return Column(
      children: [
        Container(
          child: Text(
            boatList[index].name,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          child: Text(
            'By ${boatList[index].manufacturer}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () {
            _onTap();
          },
          child: Container(
            child: Text(
              'SPECS >',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFullDescription(
      List<Boats> boatList, int index, CurvedAnimation _curvedAnimation) {
    final double? y =
        lerpDouble(0, -250, (_curvedAnimation.value).clamp(0.0, 1.0));
    return Container(
      transform: Matrix4.identity()..translate(0.0, y ?? 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              boatList[index].name,
              style: TextStyle(
                  fontSize: 25 * (_curvedAnimation.value + 0.25),
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'By ${boatList[index].manufacturer}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
                'Lorem ipsum dolor sit amet consectetur adipiscing elit placerat, nisl venenatis quisque nostra sodales aliquam maecenas, aptent quam sem tincidunt'),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'SPEC',
              style: TextStyle(
                fontSize: 20 * (_curvedAnimation.value + 0.25),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: buildSpecsTable(
                  boatList[index].specs ?? {}, _curvedAnimation)),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'GALLERY',
              style: TextStyle(
                fontSize: 20 * (_curvedAnimation.value + 0.25),
              ),
            ),
          ),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return Container(
                  padding: EdgeInsets.all(15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/images/gallery${index + 1}.jpg'),
                  ),
                );
              },
              itemCount: 4,
            ),
          )
        ],
      ),
    );
  }

  Table buildSpecsTable(
      Map<String, dynamic?> specs, CurvedAnimation _curvedAnimation) {
    List<TableRow> listTableRows = [];

    specs.forEach((key, value) {
      listTableRows.add(TableRow(children: [
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 10),
          child: Text(
            key.toString(),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.normal,
              letterSpacing: 2,
            ),
          ),
        ),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ]));
    });

    return Table(
      children: listTableRows,
    );
  }

  void _onTap() {
    if (_animationController.isCompleted) {
      isDetailClosed = true;
      _scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 50), curve: Curves.linear);

      _curvedAnimation.curve = CustomCurveOut();
      _animationController.reverse();
    } else {
      isDetailClosed = false;
      _curvedAnimation.curve = CustomCurveIn();
      _animationController.forward();
    }
  }
}

List<Boats> getDummyListBo() {
  List<Boats> list = [];

  Boats boat = new Boats(
      imgUrl: 'assets/images/boat1.png',
      description:
          'description descriptiondescription descriptiondescription descriptiondescription description',
      manufacturer: 'Titanic',
      name: 'X24 Forcec',
      specs: {
        'Boat Lenght': "24' 2",
        'Beam': "102'",
        'Weight': '2767 KG',
        'Fuel Capacity': '322 L'
      });
  Boats boat2 = new Boats(
      imgUrl: 'assets/images/boat2.png',
      description:
          'description descriptiondescription descriptiondescription descriptiondescription description',
      manufacturer: 'Baywatch',
      name: 'X11 Speed',
      specs: {
        'Boat Lenght': "24' 2",
        'Beam': "102'",
        'Weight': '2767 KG',
        'Fuel Capacity': '322 L'
      });
  Boats boat3 = new Boats(
      imgUrl: 'assets/images/boat3.png',
      description:
          'description descriptiondescription descriptiondescription descriptiondescription description',
      manufacturer: 'Hulk',
      name: 'Thunder Storm',
      specs: {
        'Boat Lenght': "24' 2",
        'Beam': "102'",
        'Weight': '2767 KG',
        'Fuel Capacity': '322 L'
      });
  Boats boat4 = new Boats(
      imgUrl: 'assets/images/boat4.png',
      description:
          'description descriptiondescription descriptiondescription descriptiondescription description',
      manufacturer: 'BMW',
      name: 'X34 ForceX',
      specs: {
        'Boat Lenght': "24' 2",
        'Beam': "102'",
        'Weight': '2767 KG',
        'Fuel Capacity': '322 L'
      });
  Boats boat5 = new Boats(
      imgUrl: 'assets/images/boat5.png',
      description:
          'description descriptiondescription descriptiondescription descriptiondescription description',
      manufacturer: 'Speed Boats',
      name: 'X22 Fun',
      specs: {
        'Boat Lenght': "24' 2",
        'Beam': "102'",
        'Weight': '2767 KG',
        'Fuel Capacity': '322 L'
      });

  list.add(boat);
  list.add(boat2);
  list.add(boat3);
  list.add(boat4);
  list.add(boat5);

  return list;
}
