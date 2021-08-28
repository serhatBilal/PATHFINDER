import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class ProfilSayfasi extends StatelessWidget {
  const ProfilSayfasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Sayfası"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) =>
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                        (route) => false));
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: const KullaniciBilgi(),
      ),
    );
  }
}

class KullaniciBilgi extends StatelessWidget {
  const KullaniciBilgi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth kullanici = FirebaseAuth.instance;

    Query users = FirebaseFirestore.instance
        .collection('Kullanicilar')
        .where('kullaniciID', isEqualTo: kullanici.currentUser!.uid);
    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Bir şeyler ters gitti');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Yukleniyor");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text("Kullanici Adiniz : " + data['KullaniciAdi']),
              subtitle: Text(
                  "Kullanici Email Adresiniz : " + data['KullaniciEposta']),
            );
          }).toList(),
        );
      },
    );
  }
}
