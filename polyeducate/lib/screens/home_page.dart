
import 'dart:convert';

import 'package:polyeducate/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/appointment_card.dart';
import '../components/professor_card.dart';
import '../main.dart';
import '../models/auth_model.dart';
import '../providers/dio_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};
  Map<String, dynamic> professor = {};
  List<dynamic> favList =[];

  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.school,
      "category": "Math",
    },
    {
      "icon": FontAwesomeIcons.school,
      "category": "Physics",
    },
    {
      "icon": FontAwesomeIcons.school,
      "category": "Programming",
    },
    {
      "icon": FontAwesomeIcons.school,
      "category": "Science",
    },
    {
      "icon": FontAwesomeIcons.school,
      "category": "Law",
    },
    {
      "icon": FontAwesomeIcons.school,
      "category": "Art",
    },
  ];









  @override
  Widget build(BuildContext context) {
    Config().init(context);
    user = Provider.of<AuthModel>(context, listen: false).getUser;
    professor = Provider.of<AuthModel>(context, listen: false).getAppointment;
    favList = Provider.of<AuthModel>(context, listen: false).getFav;

    return Scaffold(
      //if user is empty, then return progress indicator
      body: user.isEmpty?
          const Center(
        child: CircularProgressIndicator(),
      )
      :Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                     user['name'],
                      //hard core name at first
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                        AssetImage('assets/profile1.jpg'),
                      ),



                    )
                  ],
                ),
                Config.spaceMedium,
                //category listing ..

                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Config.spaceSmall,


                SizedBox(
                  height: Config.heightSize * 0.05,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                    List<Widget>.generate(medCat.length, (index) {
                      return Card(
                        margin: const EdgeInsets.only(right: 20),
                        color: Config.primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              FaIcon(
                                medCat[index]['icon'],
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                medCat[index]['category'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                Config.spaceSmall,


                professor.isNotEmpty ?
                AppointmentCard(
                  professor: professor,
                  color: Config.primaryColor,
                )
                    : Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No Classes for Today (づ｡◕‿‿◕｡)づ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),





                Config.spaceSmall,

                Column(
                  children: List.generate(user['professor'].length, (index) {
                    return ProfessorCard(
                      professor: user['professor'][index],
                      //if lates fav list contains particular professor id, then show fav icon
                      isFav: favList
                          .contains(user['professor'][index]['prof_id'])
                          ? true
                          : false,
                    );
                  }),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
