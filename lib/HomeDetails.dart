import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeDetails extends StatelessWidget{

  final String title;
  final String description;
  final String image;

  HomeDetails(this.title, this.description, this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Container(
                  height: 20,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(image),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  height: 30,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    title,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5
                    )
                )
              ],
            ),
            Row(
              children: [
                Container(
                  height: 30,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width/1.1,
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      children: [
                        Text(
                          description,
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: .5
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                )
              ],
            ),
            Row(
              children: [
                Container(
                  height: 30,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

}