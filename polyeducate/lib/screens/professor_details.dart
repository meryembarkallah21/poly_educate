import 'package:polyeducate/components/button.dart';
import 'package:polyeducate/models/auth_model.dart';
import 'package:polyeducate/providers/dio_provider.dart';
import 'package:polyeducate/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components//custom_appbar.dart';

class ProfessorDetails extends StatefulWidget {
  const ProfessorDetails({Key? key, required this.professor, required this.isFav})
      : super(key: key);
  final Map<String, dynamic> professor;
  final bool isFav;

  @override
  State<ProfessorDetails> createState() => _ProfessorDetailsState();
}

class _ProfessorDetailsState extends State<ProfessorDetails> {
  Map<String, dynamic> professor = {};
  bool isFav = false;

  @override
  void initState() {
    professor = widget.professor;
    isFav = widget.isFav;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Professor Details',
        icon: const FaIcon(Icons.arrow_back_ios),
        actions: [
          //Favarite Button
          IconButton(
            //press this button to add/remove favorite professor
            onPressed: () async {
              //get latest favorite list from auth model
              final list =
                  Provider.of<AuthModel>(context, listen: false).getFav;

              //if prof id is already exist, mean remove the prof id
              if (list.contains(professor['prof_id'])) {
                list.removeWhere((id) => id == professor['prof_id']);
              } else {
                //else, add new professor to favorite list
                list.add(professor['prof_id']);
              }

              //update the list into auth model and notify all widgets
              Provider.of<AuthModel>(context, listen: false).setFavList(list);

              final SharedPreferences prefs =
              await SharedPreferences.getInstance();
              final token = prefs.getString('token') ?? '';

              if (token.isNotEmpty && token != '') {
                //update the favorite list into database
                final response = await DioProvider().storeFavProf(token, list);
                //if insert successfully, then change the favorite status

                if (response == 200) {
                  setState(() {
                    isFav = !isFav;
                  });
                }
              }
            },
            icon: FaIcon(
              isFav ? Icons.favorite_rounded : Icons.favorite_outline,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AboutProfessor(
              professor: professor,
            ),
            DetailBody(
              professor: professor,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Button(
                width: double.infinity,
                title: 'Book Appointment',
                onPressed: () {
                  Navigator.of(context).pushNamed('booking_page',
                      arguments: {"professor_id": professor['prof_id']});
                },
                disable: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutProfessor extends StatelessWidget {
  const AboutProfessor({Key? key, required this.professor}) : super(key: key);

  final Map<dynamic, dynamic> professor;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          const CircleAvatar(
              backgroundImage:
              AssetImage('assets/prof1.jpg')
          ),
          Config.spaceMedium,
          Text(
            "Professor ${professor['professor_name']}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'Graduated from Faculty of Sciences of Tunis',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'Polytechnic School of Sousse',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}


class DetailBody extends StatelessWidget {
  const DetailBody({Key? key, required this.professor}) : super(key: key);
  final Map<dynamic, dynamic> professor;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Config.spaceSmall,
          ProfessorInfo(
            students: professor['students'],
            exp: professor['experience'],
          ),
          Config.spaceMedium,
          const Text(
            'About Professor',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Config.spaceSmall,
          Text(
            'Mr/Mrs. ${professor['professor_name']} is an experienced ${professor['category']} Professor , graduated since 2008.',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            softWrap: true,
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}

class ProfessorInfo extends StatelessWidget {
  const ProfessorInfo({Key? key, required this.students, required this.exp})
      : super(key: key);

  final int students;
  final int exp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InfoCard(
          label: 'Students',
          value: '$students',
        ),
        const SizedBox(
          width: 15,
        ),
        InfoCard(
          label: 'Experiences',
          value: '$exp years',
        ),
        const SizedBox(
          width: 15,
        ),
        const InfoCard(
          label: 'Rating',
          value: '4.7',
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key, required this.label, required this.value})
      : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Config.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
