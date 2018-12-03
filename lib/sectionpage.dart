import 'dart:convert';
import 'dart:async';
import 'package:darksdkapp/drawer.dart';
import 'package:darksdkapp/section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipedetector/swipedetector.dart';

class SectionPage extends StatefulWidget {
  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
    
  Future<SharedPreferences> _sPrefs = SharedPreferences.getInstance();
  List<Paths> list = new List();
  DateTime now = DateTime.now();
  int timeDifference = 0;
  DateTime previousTime;
  bool _isLoading;
  double containerSize = 52.0;
  double barOffset = 0.0;
  ScrollController scrollController = new ScrollController();
  
  @override
  initState() {
    super.initState();
    _isLoading = true;
    firstRun();  
  }

  @override
  void dispose() {
    super.dispose();
  }


  Future<Null> addData(String key, String data) async {
    final SharedPreferences prefs = await _sPrefs;
    
    prefs.setString(key, data);
    setState(() {
      
    });
  }

  Future<Null> clearItems() async {
    final SharedPreferences prefs = await _sPrefs;
    prefs.clear();
    setState(() {
      
    });
  }

  Future<String> getString(String key, String data) async {
   data = await _sPrefs.then((sprefs) {
      return sprefs.getString(key);
    });
  }
  
  Sdk sdk;
  List<DynamicSections> results;

  void firstRun() async {
    try  {
      final result = await InternetAddress.lookup('google.com');
      if (result != null && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        
        now = DateTime.now();
        var prevTime;
        getString('last_time', prevTime);
        if(prevTime != null ) {
          previousTime = DateTime.parse(prevTime);
          if(previousTime.difference(now).inSeconds > 10)  {
            fetchNews();
          
            addData('local_time', "$now");  
          } 
        } else {
          fetchNews();
          addData('local_time', "$now");  
        }
        
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  Future<void> fetchNews() async {
    setState(() {
      _isLoading = true;      
    });
    
    var res = await http.get('http://www.omgoa.com/scripts/dataTableNayaDynamicIndex.py');
    var decRes = jsonDecode(res.body);
  
    sdk = Sdk.fromJson(decRes);
    results = sdk.dynamicSections;
    
    if(res.statusCode > 100) {
      
    }

     list.clear();
      for(var i = 0; i < results.length; i++) {
      
        await loadList(i, 0);
        if(i == results.length -1) {
          setState(() {
            _isLoading = false;      
          });
        }
      };
    
  
  }
  
  _launchURL(String path) async {
    var url = path;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget getSecondList(int index)
  {
    List<Widget> listing = new List<Widget>();
      if(list[index].result != null) {
        for(var i = 0; i < list[index].result.length; i++){

          listing.add(Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                 
                    setState(() {
                      if(barOffset > scrollController.position.maxScrollExtent) {
                        barOffset = scrollController.position.maxScrollExtent;
                      } else if( barOffset < scrollController.position.minScrollExtent) {
                        barOffset = scrollController.position.minScrollExtent;
                      } else {
                        barOffset = barOffset - details.delta.dy;
                      }
                      
                      
                      scrollController.jumpTo(barOffset);
                  });
                
              },
              onTap: () => _launchURL(list[index].result[i][2]),
              child: Text(
                list[index].result[i][1],
                style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0XFF2e9ddc),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'mermaid',
                  letterSpacing: 1.5,
                ),  
              ),
            ),
          )
        );
      }
    }
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: listing
      
      );
  }

  Widget getFirstList()
  {
    List<Widget> listingfirst = new List<Widget>();
      if(results != null) {
        for(var index = 0; index < results.length; index++){

          listingfirst.add(results[index].backgroundColor.startsWith('hiddenitem') ? Container() : Card( 
            child:SwipeDetector(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Section ${results[index].name} $index",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'bebas-neue',
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Checkbox(
                          value: !results[index].backgroundColor.startsWith('hiddenitem'),
                          activeColor: Color(0xFF396b9e),
                          onChanged: (bool newValue) {
                            setState(() {

                              if(results[index].backgroundColor.startsWith('hiddenitem')) {
                                results[index].backgroundColor = results[index].backgroundColor.substring(10);
                              } else {
                                results[index].backgroundColor = "hiddenitem" + results[index].backgroundColor;
                              }
                              
                              
                            });
                          }),

                      ],
                    ),

                    getSecondList(index)
                              
                  ],
                
                ),
              ),
              onSwipeRight: () async {
                print('right swipe');
                await loadList(index, list[index].result.length + 10.0);
               
              },
              onSwipeLeft: ()  {
                print('left swipe');
                setState(() {
                                      
                });
              },
              swipeConfiguration: SwipeConfiguration(
                    verticalSwipeMinVelocity: 100.0,
                    verticalSwipeMinDisplacement: 50.0,
                    verticalSwipeMaxWidthThreshold:100.0,
                    horizontalSwipeMaxHeightThreshold: 50.0,
                    horizontalSwipeMinDisplacement:50.0,
                    horizontalSwipeMinVelocity: 200.0),
            ),
          )
        );
      }
    }
   
    return SingleChildScrollView(
      controller: scrollController,
      child: new Column(children: listingfirst)
      );
  }

  Future<void> loadList(i, limit) async {
    var pathurl;
    if(limit == 0) {
      pathurl = results[i].href;
    } else {
      pathurl = results[i].href.replaceAll('limit=10', 'limit=${(limit.toInt())}');
    
    }
    
      var pathlist = await http.get(Uri.parse('http://$pathurl'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        });
    var pathDecRes = jsonDecode(pathlist.body);
          
    var pathsdk = Paths.fromJson(pathDecRes);
    if(limit == 0) {
      
      list.add(pathsdk);
    } else {
     

      setState(() {
        list[i] = pathsdk;        
      });
      
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "dark sdk app",
      home: Scaffold(
        backgroundColor: Color(0xFFF3F3F3),
        appBar: AppBar(
          backgroundColor: Color(0XFF396B9E),
          centerTitle: true,
          title: Text(
            "APP TITLE",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 3.0
            ),
          ),
        ),        
        body: _isLoading ? Center(child: CircularProgressIndicator() ) :  Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    timeDifference > 0 ? "LAST UPDATED ON ${DateFormat('dd/MM/yy').format(previousTime)}" : "LAST UPDATED ON ${DateFormat('dd/MM/yy').format(now)}",
                    
                    style: TextStyle(
                      fontFamily: 'bebas-neue',
                      color: Color(0XFF2e9ddc),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0
                    ),
                    softWrap: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: OutlineButton(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                    
                    onPressed: () {
                      // todo
                      timeDifference = 0; 
                      fetchNews();
                    },
                    child: Text(
                      "Update Now",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFF2e9ddc),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'bebas-neue',
                        letterSpacing: 2.0
                      ),
                      ),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0), side: BorderSide(width: 3.0, color: Color(0XFF2e9ddc), style: BorderStyle.solid)),
                
                  ),
                )
                ],
              ),
            ),
          
            Expanded(child: getFirstList())
            
          ],
        ),
        drawer: SectionDrawer(results: results),
      ),
    );
  }
}


