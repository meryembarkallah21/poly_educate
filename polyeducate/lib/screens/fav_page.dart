import "package:polyeducate/components/professor_card.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../models/auth_model.dart";

class FavPage extends StatefulWidget {
  FavPage({Key? key}) : super(key: key);

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          children: [
            const Text(
              'My Favorite Professors',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),



            Expanded(
              child: Consumer<AuthModel>(
                builder: (context, auth, child) {
                  return ListView.builder(
                    itemCount: auth.getFavProf.length,
                    itemBuilder: (context, index) {
                      return ProfessorCard(
                        professor: auth.getFavProf[index],
                        //show fav icon
                        isFav: true,
                      );
                    },
                  );
                },
                //child:
              ),
            ),
          ],
        ),
      ),
    );
  }
}
