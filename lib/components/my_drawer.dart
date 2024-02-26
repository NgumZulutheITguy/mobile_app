import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/components/my_list_tile.dart';
import 'package:mobile_app/pages/profile_page.dart';
import '../pages/generateBarcode.dart';
import '../pages/calc.dart';
import '../pages/history_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  //header
                  DrawerHeader(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                        'lib/images/contra.png',
                      ),
                    ),
                  ),
                  //home
                  MyListTile(
                    icon: Icons.home,
                    text: 'H O M E ',
                    onTap: () => Navigator.pop(context),
                  ),
                  //profile
                  MyListTile(
                      icon: Icons.person,
                      text: 'P R O F I L E',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const ProfilePage();
                            },
                          ),
                        );
                      }),
                       //Scan Barcode
                  MyListTile(
                    icon: Icons.document_scanner_rounded,
                    text: 'G E N E R A T E\nB A R C O D E',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const GenerateBarcodePage();
                          },
                        ),
                      );
                    },
                  ),
                  //History
                  MyListTile(
                    icon: Icons.inventory,
                    text: 'H I S T O R Y',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const HistoryPage();
                          },
                        ),
                      );
                    },
                  ),
                  MyListTile(
                    icon: Icons.calculate,
                    text: 'C A L C U L A T O R',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const CalculatorPage();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

//logout button
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: MyListTile(
                icon: Icons.login_rounded,
                text: 'L O G O U T',
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
            )
          ],
        ));
  }
}
