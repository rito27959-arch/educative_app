// Une page d'onglet à la manière d'iOS : grand titre qui se replie en titre
// compact dans une barre floutée quand on fait défiler, rebond en bout de
// liste. Habillée aux couleurs de Kunfox.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/palette.dart';

class PageIOS extends StatelessWidget {
  const PageIOS({super.key, required this.titre, this.sousTitre, required this.enfants, this.margeBas = 120});

  final String titre;
  final String? sousTitre;
  final List<Widget> enfants;
  final double margeBas;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: p.sombre ? Brightness.dark : Brightness.light,
        primaryColor: p.prim,
        barBackgroundColor: p.fond.withValues(alpha: 0.82),
        scaffoldBackgroundColor: p.fond,
        textTheme: CupertinoTextThemeData(
          primaryColor: p.prim,
          navLargeTitleTextStyle: TextStyle(
              fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 34, letterSpacing: -0.8, color: p.texte),
          navTitleTextStyle: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 17, color: p.texte),
        ),
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(titre),
            transitionBetweenRoutes: false,
            border: Border(bottom: BorderSide(color: p.bord.withValues(alpha: 0.6), width: 0.5)),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, margeBas),
            sliver: SliverList.list(children: [
              if (sousTitre != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(sousTitre!, style: TextStyle(color: p.doux, fontWeight: FontWeight.w600, fontSize: 15)),
                ),
              ...enfants,
            ]),
          ),
        ],
      ),
    );
  }
}
