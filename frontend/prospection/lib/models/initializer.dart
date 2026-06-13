import 'source.dart';
import 'fiche.dart';
import '../models/localStorage/local_storage.dart';

class Initializer {

  Fiche fiche;
  Source src;
  
  Initializer({required this.src, required this.fiche});
  

// 1. Sauvegarder la Source
  void setSourceAndFiche() async {

    // late final src = Source(
    //   idSource: DateTime.now().millisecondsSinceEpoch.toString(),
    //   libelleSource: 'Sur le terrain',
    //   createdAt: now,
    // );
    await LocalStorage.instance.saveSource(src);

// 4. Créer et sauvegarder la Fiche
    // final fiche = Fiche(
    //   idFiche: 'fiche_${DateTime.now().millisecondsSinceEpoch}',
    //   idSrc: src.idSource, 
    //   dateCollecte: now,
    //   // commentaire:
    //   //     _commentaireCtrl.text.isEmpty ? null : _commentaireCtrl.text,
    //   // scoreInteret: _scoreInteret,
    //   createdAt: now,
    //   isCurrent: true,
    // );
    await LocalStorage.instance.saveFiche(fiche); // ← Sauvegarde immédiate
  }

  // Source get_source() {
  //   return src;
  // }

  // Fiche get_fiche() {
  //   return fiche;
  // }
}

