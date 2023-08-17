import 'package:polyeducate/main.dart';
import 'package:polyeducate/screens/professor_details.dart';
import 'package:polyeducate/utils/config.dart';
import 'package:flutter/material.dart';

class ProfessorCard extends StatelessWidget {
  const ProfessorCard({
    Key? key,
    required this.professor,
    required this.isFav,
  }) : super(key: key);

  final Map<String, dynamic> professor;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              const SizedBox(
                child: CircleAvatar(
                    backgroundImage:
                    AssetImage('assets/prof1.jpg')
                ),
              ),
              Flexible(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Mr/Mrs. ${professor['professor_name']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${professor['category']}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const <Widget>[
                          Icon(
                            Icons.star_border,
                            color: Colors.yellow,
                            size: 16,
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Text('4.5'),
                          Spacer(
                            flex: 1,
                          ),
                          Text('Reviews'),
                          Spacer(
                            flex: 1,
                          ),
                          Text('(20)'),
                          Spacer(
                            flex: 7,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          //pass the details to detail page
          MyApp.navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (_) => ProfessorDetails(
                professor: professor,
                isFav: isFav,
              )));
        },
      ),
    );
  }
}
