import 'package:darksdkapp/section.dart';
import 'package:flutter/material.dart';


class SectionDrawer extends StatefulWidget {
  List<DynamicSections> results;
  SectionDrawer({
    @required this.results
  });
  @override
  _SectionDrawerState createState() => _SectionDrawerState();
}

class _SectionDrawerState extends State<SectionDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: widget.results != null ? widget.results.length: 0,
          itemBuilder: (BuildContext context, int index) {
            return new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Section ${widget.results[index].name}",
                  style: TextStyle(
                    fontFamily: 'bebas-neue',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 2.0
                  ),
                ),
                Checkbox(
                  value: !widget.results[index].backgroundColor.startsWith('hiddenitem'),
                  activeColor: Color(0xFF396b9e),
                  onChanged: (bool newValue) {
                    setState(() {

                      if(widget.results[index].backgroundColor.startsWith('hiddenitem')) {
                        widget.results[index].backgroundColor = widget.results[index].backgroundColor.substring(10);
                      } else {
                        widget.results[index].backgroundColor = "hiddenitem" + widget.results[index].backgroundColor;
                      }
                    
                    });
                  }),

              ],
            );
          },
        ),
      )
    );
  }
}