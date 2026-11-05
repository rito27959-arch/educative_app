// Le texte riche de Kunfox, pour les cours, les énoncés et les corrigés.
//
//   Texte avec une formule $f(x)=e^{-x}$ en ligne et du **gras**.
//   $$\int_0^1 x^2\,dx=\frac13$$          ← formule centrée
//   ## Titre
//   - une puce
//   > Propriété : un encadré coloré
//   ```graphe … ```  ```variations … ```  ```tableau … ```
//
// Un texte sans aucune de ces marques s'affiche simplement : les anciens
// cours restent lisibles tels quels.

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../theme/palette.dart';
import 'graphe.dart';
import 'tableaux.dart';

sealed class _Bloc {}

class _Paragraphe extends _Bloc {
  _Paragraphe(this.texte);
  final String texte;
}

class _Titre extends _Bloc {
  _Titre(this.texte);
  final String texte;
}

class _Puces extends _Bloc {
  _Puces(this.items);
  final List<String> items;
}

class _Encadre extends _Bloc {
  _Encadre(this.texte);
  final String texte;
}

class _FormuleBloc extends _Bloc {
  _FormuleBloc(this.tex);
  final String tex;
}

class _Special extends _Bloc {
  _Special(this.genre, this.source);
  final String genre;
  final String source;
}

List<_Bloc> _decouper(String source) {
  final blocs = <_Bloc>[];
  final lignes = source.replaceAll('\r', '').split('\n');
  var i = 0;
  final para = <String>[];

  void fermerPara() {
    if (para.isNotEmpty) {
      blocs.add(_Paragraphe(para.join('\n').trim()));
      para.clear();
    }
  }

  while (i < lignes.length) {
    final l = lignes[i];
    final t = l.trim();
    if (t.startsWith('```')) {
      fermerPara();
      final genre = t.substring(3).trim().toLowerCase();
      final corps = <String>[];
      i++;
      while (i < lignes.length && !lignes[i].trim().startsWith('```')) {
        corps.add(lignes[i]);
        i++;
      }
      blocs.add(_Special(genre, corps.join('\n')));
      i++;
      continue;
    }
    if (t.startsWith(r'$$')) {
      fermerPara();
      var tex = t.substring(2);
      if (tex.endsWith(r'$$') && tex.length >= 2) {
        blocs.add(_FormuleBloc(tex.substring(0, tex.length - 2)));
        i++;
        continue;
      }
      i++;
      while (i < lignes.length && !lignes[i].trim().endsWith(r'$$')) {
        tex += '\n${lignes[i]}';
        i++;
      }
      if (i < lignes.length) {
        final f = lignes[i].trim();
        tex += '\n${f.substring(0, f.length - 2)}';
      }
      blocs.add(_FormuleBloc(tex));
      i++;
      continue;
    }
    if (t.isEmpty) {
      fermerPara();
    } else if (t.startsWith('## ') || t.startsWith('### ')) {
      fermerPara();
      blocs.add(_Titre(t.replaceFirst(RegExp(r'^#+\s'), '')));
    } else if (t.startsWith('- ') || t.startsWith('• ')) {
      fermerPara();
      final items = <String>[];
      while (i < lignes.length && (lignes[i].trim().startsWith('- ') || lignes[i].trim().startsWith('• '))) {
        items.add(lignes[i].trim().substring(2));
        i++;
      }
      blocs.add(_Puces(items));
      continue;
    } else if (t.startsWith('> ')) {
      fermerPara();
      final enc = <String>[];
      while (i < lignes.length && lignes[i].trim().startsWith('>')) {
        enc.add(lignes[i].trim().replaceFirst(RegExp(r'^>\s?'), ''));
        i++;
      }
      blocs.add(_Encadre(enc.join('\n')));
      continue;
    } else {
      // les retours à la ligne d'un paragraphe sont gardés
      para.add(t);
    }
    i++;
  }
  fermerPara();
  return blocs;
}

/// Le texte en ligne : formules $…$ et **gras**.
List<InlineSpan> spansRiches(String texte, TextStyle style) {
  final spans = <InlineSpan>[];
  final motif = RegExp(r'\$([^$]+)\$|\*\*([^*]+)\*\*|`([^`]+)`');
  var debut = 0;
  for (final m in motif.allMatches(texte)) {
    if (m.start > debut) spans.add(TextSpan(text: texte.substring(debut, m.start)));
    if (m[1] != null) {
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Math.tex(
          m[1]!,
          mathStyle: MathStyle.text,
          textStyle: style.copyWith(fontWeight: FontWeight.w500),
          onErrorFallback: (_) => Text(m[1]!, style: style),
        ),
      ));
    } else if (m[2] != null) {
      spans.add(TextSpan(text: m[2], style: const TextStyle(fontWeight: FontWeight.w800)));
    } else {
      spans.add(TextSpan(
        text: m[3],
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: (style.fontSize ?? 16) * 0.92,
          fontWeight: FontWeight.w600,
          backgroundColor: (style.color ?? Colors.black).withValues(alpha: 0.08),
        ),
      ));
    }
    debut = m.end;
  }
  if (debut < texte.length) spans.add(TextSpan(text: texte.substring(debut)));
  return spans;
}

class TexteRiche extends StatelessWidget {
  const TexteRiche(this.texte, {super.key, this.style, this.textAlign = TextAlign.start});
  final String texte;
  final TextStyle? style;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final st = style ?? TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w500, color: p.texte);
    if (!texte.contains(r'$') && !texte.contains('**') && !texte.contains('`')) return Text(texte, style: st, textAlign: textAlign);
    return Text.rich(TextSpan(style: st, children: spansRiches(texte, st)), textAlign: textAlign);
  }
}

class ContenuRiche extends StatelessWidget {
  const ContenuRiche(this.source, {super.key, this.style, this.espacement = 12});
  final String source;
  final TextStyle? style;
  final double espacement;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final st = style ?? TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w500, color: p.texte);
    final blocs = _decouper(source);
    final enfants = <Widget>[];
    for (final b in blocs) {
      if (enfants.isNotEmpty) enfants.add(SizedBox(height: espacement));
      enfants.add(switch (b) {
        _Paragraphe(:final texte) => TexteRiche(texte, style: st),
        _Titre(:final texte) => Padding(
            padding: const EdgeInsets.only(top: 4),
            child: TexteRiche(texte,
                style: st.copyWith(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: (st.fontSize ?? 16) + 3)),
          ),
        _Puces(:final items) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (final it in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: EdgeInsets.only(top: (st.fontSize ?? 16) * 0.55, right: 10),
                    child: Container(width: 7, height: 7, decoration: BoxDecoration(color: p.prim, shape: BoxShape.circle)),
                  ),
                  Expanded(child: TexteRiche(it, style: st)),
                ]),
              ),
          ]),
        _Encadre(:final texte) => Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: p.info.withValues(alpha: p.sombre ? 0.16 : 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border(left: BorderSide(color: p.info, width: 4)),
            ),
            child: ContenuRiche(texte, style: st, espacement: 8),
          ),
        _FormuleBloc(:final tex) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width - 48),
                child: Center(
                  child: Math.tex(
                    tex.trim(),
                    mathStyle: MathStyle.display,
                    textStyle: st.copyWith(fontSize: (st.fontSize ?? 16) + 1),
                    onErrorFallback: (_) => Text(tex, style: st),
                  ),
                ),
              ),
            ),
          ),
        _Special(:final genre, :final source) => switch (genre) {
            'graphe' || 'courbe' => Graphe(source: source),
            'variations' || 'signes' => TableauVariations(source: source),
            'tableau' => TableauSimple(source: source),
            _ => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF14213D),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(source,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 14, height: 1.45, color: Color(0xFFE8ECF8))),
                ),
              ),
          },
      });
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: enfants);
  }
}
