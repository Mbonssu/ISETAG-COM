import 'package:uuid/uuid.dart';

class Generator {

  static Generator instance = Generator._internal();
  Generator._internal();

  static String generateShortId(String prefix, {int maxLength = 25}) {
    final uuid = const Uuid().v4().replaceAll('-', '');
    // Prendre les 10 premiers caractères de l'UUID
    final shortUuid = uuid.substring(0, 10);
    String id = '$prefix$shortUuid';

    if (id.length > maxLength) {
      // Si trop long, réduire le prefix
      final shortPrefix =
          prefix.substring(0, prefix.length > 5 ? 5 : prefix.length);
      id =
          '$shortPrefix${shortUuid.substring(0, maxLength - shortPrefix.length)}';
    }

    return id;
  }
}
