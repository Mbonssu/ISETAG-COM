// lib/utils/legal_texts.dart


import 'package:package_info_plus/package_info_plus.dart';

class LegalTexts {
  // Version is usually fetched dynamically, but you can hardcode it here.

  String appVersion = '1.0.0';

    static Future<String> getAppVersion() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      
      return packageInfo.version;
    } catch (e) {
      // Fallback in case of error
      return '1.0.0';
    }
  }

  // Terms of Use (extracted from licence-utilisation-ecin.docx)
  static const String termsOfUse = '''
**ECIN DIGITAL CORP**

**Contrat de Licence d'Utilisation Logicielle**

*Application : ISETAG PROSPECTION --- Édition professionnelle*

*Version du modèle : à faire relire par un conseil juridique avant toute signature*

Entre les soussignés :

**ECIN DIGITAL CORP**, *[forme juridique --- ex. Établissement / SARL en cours d'immatriculation]*, dont le siège est situé à *[adresse complète, Douala, Cameroun]*, immatriculée sous le numéro *[RCCM / N° Contribuable]*, représentée par *[Nom du représentant, qualité]*, ci-après dénommée « le Concédant » ou « ECIN »,

D'une part,

**ET :** *[Raison sociale du client]*, dont le siège est situé à *[adresse du client]*, représentée par *[nom, qualité]*, ci-après dénommée « le Licencié » ou « le Client »,

D'autre part,

Le Concédant et le Client étant ci-après désignés ensemble « les Parties » et individuellement « une Partie ».

**1. Préambule**

ECIN Digital Corp a développé une application logicielle de prospection commerciale (ci-après « le Logiciel ») destinée à permettre à ses utilisateurs de gérer, suivre et organiser leurs activités de prospection : constitution de fichiers de prospects, suivi des relances, gestion des opportunités commerciales, reporting et fonctionnalités associées.

Le Client souhaite utiliser le Logiciel dans le cadre de son activité professionnelle. Les Parties conviennent que le Logiciel n'est pas vendu mais concédé sous licence, dans les conditions définies au présent contrat.

**2. Définitions**

**Logiciel :** désigne l'application de prospection [NOM DE L'APPLICATION], son code source, son code objet, ses interfaces utilisateur, sa base de données, sa documentation et l'ensemble de ses composants, dans toutes ses versions présentes et futures.

**Licence :** désigne le droit d'usage non exclusif et non transférable concédé au Client sur le Logiciel, dans les conditions et limites du présent contrat.

**Utilisateur autorisé :** désigne toute personne physique employée ou mandatée par le Client, dûment habilitée à accéder au Logiciel dans la limite du nombre de comptes/sièges souscrits.

**Données du Client :** désigne l'ensemble des données saisies, importées ou générées par le Client et ses Utilisateurs autorisés via le Logiciel, notamment les fichiers de prospects et les données de suivi commercial.

**Mises à jour :** désigne les corrections, améliorations, nouvelles versions mineures ou majeures du Logiciel fournies par le Concédant dans le cadre de la maintenance.

**3. Objet du contrat**

Le présent contrat a pour objet de définir les conditions dans lesquelles ECIN Digital Corp concède au Client, à titre onéreux, une licence d'utilisation du Logiciel, ainsi que les droits et obligations réciproques des Parties.

**4. Propriété intellectuelle**

**Le Logiciel demeure la propriété exclusive de ECIN Digital Corp.** Cela inclut notamment le code source, l'architecture technique, les interfaces graphiques (UI/UX), les bases de données structurelles, les algorithmes, la documentation, ainsi que les marques, logos et éléments graphiques associés au Logiciel et à ECIN Digital Corp.

Le Client ne bénéficie, au titre du présent contrat, d'aucun transfert de propriété intellectuelle. Il bénéficie uniquement d'un droit d'usage non exclusif tel que défini à l'Article 5.

Toute reproduction, décompilation, désassemblage ou ingénierie inverse du Logiciel, en tout ou partie, est strictement interdite, sauf dans les cas où la loi applicable l'autoriserait de manière impérative et nonobstant toute clause contraire.

**5. Concession de licence**

**5.1 Nature de la licence**

ECIN concède au Client une licence d'utilisation du Logiciel qui est :

- Non exclusive : ECIN demeure libre de concéder des licences sur le même Logiciel à d'autres clients ;

- Non transférable et non cessible, sauf accord écrit préalable d'ECIN ;

- Limitée à un usage professionnel interne, pour les besoins propres de l'activité de prospection du Client ;

- Limitée au nombre d'Utilisateurs autorisés et/ou de sièges souscrits, précisé dans le bon de commande ou l'annexe tarifaire.

**5.2 Ce que le Client peut faire**

- Utiliser le Logiciel conformément à sa documentation et à sa destination normale ;

- Créer les comptes des Utilisateurs autorisés dans la limite souscrite ;

- Exporter ses propres Données du Client selon les fonctionnalités prévues par le Logiciel.

**5.3 Ce que le Client ne peut pas faire**

- Revendre, sous-licencier, louer ou mettre à disposition de tiers le Logiciel ou l'accès à celui-ci ;

- Copier, dupliquer ou créer une œuvre dérivée du Logiciel ;

- Modifier, décompiler ou tenter d'accéder au code source du Logiciel ;

- Retirer ou masquer toute mention de propriété, marque ou copyright d'ECIN ;

- Utiliser le Logiciel pour développer un produit concurrent.

**6. Obligations du Concédant**

ECIN Digital Corp s'engage à :

- Fournir un accès au Logiciel conforme à sa documentation ;

- Assurer la maintenance corrective et, selon la formule souscrite, la maintenance évolutive du Logiciel ;

- Fournir un support technique selon les modalités et horaires précisés en annexe ;

- Prendre les mesures raisonnables pour assurer la disponibilité, la sécurité et la sauvegarde des Données du Client hébergées, sans garantie de disponibilité absolue (voir Article 10).

**7. Obligations du Client**

Le Client s'engage à :

- Utiliser le Logiciel de bonne foi, conformément à sa destination et à la réglementation applicable, notamment en matière de protection des données personnelles des prospects qu'il y enregistre ;

- Garantir la confidentialité des identifiants d'accès de ses Utilisateurs autorisés ;

- S'acquitter des redevances de licence dans les délais convenus ;

- Informer ECIN de tout usage non autorisé ou faille de sécurité dont il aurait connaissance.

**8. Propriété et confidentialité des Données du Client**

Les Données du Client (notamment les fichiers de prospects saisis dans le Logiciel) demeurent la propriété exclusive du Client. ECIN agit à leur égard en qualité de sous-traitant technique au sens de la réglementation applicable en matière de protection des données personnelles.

Le traitement de ces données par ECIN, ainsi que les données relatives au Client lui-même et à ses Utilisateurs, sont régis par la Politique de Confidentialité annexée au présent contrat, qui en fait partie intégrante.

En fin de contrat, le Client dispose d'un délai de [30] jours pour exporter ses Données du Client selon les modalités prévues dans le Logiciel, à l'issue duquel ECIN pourra procéder à leur suppression, sauf obligation légale de conservation.

**9. Tarifs et modalités de paiement**

Les redevances de licence, frais d'installation, d'abonnement et de maintenance sont précisés dans le devis ou l'annexe tarifaire signée par les Parties, qui fait partie intégrante du présent contrat.

- Frais d'installation / paramétrage initial :

- Abonnement (mensuel / annuel) par Utilisateur autorisé ou par palier :

- Frais de maintenance et de support :

- Prestations de personnalisation ou d'évolution spécifique : sur devis séparé.

Sauf stipulation contraire, les redevances sont dues d'avance et non remboursables en cas de résiliation anticipée à l'initiative du Client. Tout retard de paiement pourra entraîner la suspension de l'accès au Logiciel après mise en demeure restée infructueuse pendant [15] jours.

**10. Durée et résiliation**

**Durée.** Le présent contrat est conclu pour une durée de [12] mois à compter de sa signature, renouvelable par tacite reconduction pour des périodes successives de même durée, sauf dénonciation par l'une des Parties par écrit au moins [30] jours avant l'échéance.

**Résiliation pour manquement.** En cas de manquement grave de l'une des Parties à ses obligations, non réparé dans un délai de [30] jours suivant une mise en demeure écrite restée sans effet, l'autre Partie pourra résilier le contrat de plein droit, sans préjudice de tout dommage et intérêt.

**Effets de la résiliation.** À la cessation du contrat, quelle qu'en soit la cause, le Client cesse immédiatement tout usage du Logiciel. Les dispositions relatives à la propriété intellectuelle, à la confidentialité et à la limitation de responsabilité survivent à la résiliation.

**11. Garanties et limitation de responsabilité**

ECIN s'engage à fournir le Logiciel avec un niveau de soin et de diligence raisonnable, conforme aux usages professionnels. ECIN ne garantit toutefois pas que le Logiciel sera exempt de toute erreur ou interruption.

Dans la limite autorisée par la loi applicable, la responsabilité totale d'ECIN au titre du présent contrat, tous préjudices confondus, est limitée au montant des sommes effectivement perçues par ECIN au titre de la licence au cours des douze (12) derniers mois précédant le fait générateur. ECIN ne pourra en aucun cas être tenue responsable des préjudices indirects (perte de chiffre d'affaires, perte de clientèle, perte de données résultant d'une négligence du Client, etc.).

Cette limitation ne s'applique pas en cas de faute lourde ou intentionnelle d'ECIN, ni dans les cas où la loi applicable interdirait une telle limitation.

**12. Confidentialité**

Chaque Partie s'engage à garder confidentielles toutes les informations à caractère confidentiel dont elle aurait connaissance à l'occasion de l'exécution du présent contrat, et à ne les utiliser qu'aux fins de son exécution, pendant toute sa durée et pendant [2] ans après son terme.

**13. Protection des données personnelles**

Le traitement des données à caractère personnel dans le cadre du Logiciel (données des Utilisateurs autorisés et, le cas échéant, des prospects enregistrés par le Client) est effectué conformément à la Politique de Confidentialité d'ECIN Digital Corp, annexée au présent contrat, ainsi qu'à la réglementation camerounaise applicable en matière de protection des données à caractère personnel, et le cas échéant au Règlement Général sur la Protection des Données (RGPD) si des données de personnes situées dans l'Union européenne sont concernées.

Le Client demeure responsable de traitement pour les données de ses propres prospects qu'il collecte et traite via le Logiciel ; ECIN agit en qualité de sous-traitant technique pour l'hébergement et le traitement technique de ces données.

**14. Force majeure**

Aucune des Parties ne pourra être tenue responsable d'un manquement à ses obligations résultant d'un cas de force majeure tel que défini par la jurisprudence et la loi applicables (notamment coupures prolongées d'électricité ou de réseau, catastrophe naturelle, décision gouvernementale, cyberattaque de grande ampleur non imputable à une négligence de la Partie concernée).

**15. Droit applicable et règlement des litiges**

Le présent contrat est soumis au droit camerounais. En cas de différend relatif à sa validité, son interprétation ou son exécution, les Parties s'efforceront de le résoudre à l'amiable. À défaut d'accord amiable dans un délai de [30] jours, le différend sera soumis à la compétence exclusive des tribunaux de [Douala], sous réserve de toute disposition d'ordre public contraire.

**16. Dispositions diverses**

- Intégralité de l'accord : le présent contrat, avec ses annexes (devis, Politique de Confidentialité), constitue l'intégralité de l'accord entre les Parties et annule tout accord antérieur relatif au même objet ;

- Divisibilité : si une clause du contrat est jugée nulle ou inapplicable, les autres clauses demeurent pleinement applicables ;

- Non-renonciation : le fait pour une Partie de ne pas se prévaloir d'un manquement de l'autre Partie ne vaut pas renonciation à s'en prévaloir ultérieurement ;

- Modification : toute modification du présent contrat devra faire l'objet d'un avenant écrit signé par les deux Parties.

Fait à [Douala], le [date], en deux exemplaires originaux.

+-----------------------------------+-----------------------------------+
| **Pour ECIN Digital Corp (le      | **Pour le Client (le Licencié)**  |
| Concédant)**                      |                                   |
|                                   | *Nom, qualité, signature*         |
| *Nom, qualité, signature*         |                                   |
+-----------------------------------+-----------------------------------+
  ''';

  // Privacy Policy (extracted from politique-confidentialite-ecin.docx)
  static const String privacyPolicy = '''
**ECIN DIGITAL CORP**

**Politique de Confidentialité**

*Application : [NOM DE L'APPLICATION DE PROSPECTION]*

*Dernière mise à jour : [date] --- modèle à faire relire par un conseil juridique avant publication*

**1. Qui sommes-nous**

**ECIN Digital Corp** (« ECIN », « nous ») est l'éditeur de l'application *[NOM DE L'APPLICATION]*, une solution de gestion de la prospection commerciale. Le siège d'ECIN est situé à *[adresse, Douala, Cameroun]*. Pour toute question relative à cette politique ou à vos données, vous pouvez nous contacter à l'adresse : ecinumerique@gmail.com ou par téléphone au +237 696 77 18 41.

La présente politique explique quelles données nous collectons dans le cadre de l'application, pourquoi, comment elles sont protégées, et quels sont vos droits.

**2. Deux rôles distincts : Client et ECIN**

**C'est un point important à comprendre.** L'application permet à nos clients (entreprises, indépendants) de gérer leurs propres fichiers de prospects.

- Pour les données du compte Client et des Utilisateurs autorisés (identifiants, facturation, usage de l'application), ECIN agit en tant que responsable de traitement.

- Pour les données des prospects que le Client saisit ou importe dans l'application (fichiers de prospection), le Client est responsable de traitement et ECIN agit en tant que sous-traitant technique, se contentant d'héberger et de traiter ces données pour le compte du Client, selon ses instructions.

Concrètement : si vous êtes un prospect contacté par l'un de nos clients via l'application, c'est ce client (l'entreprise qui vous démarche) qui est responsable de vos données, et non ECIN directement. Nous vous invitons à vous rapprocher de cette entreprise pour exercer vos droits, ou à nous contacter afin que nous transmettions votre demande.

**3. Données que nous collectons**

  ----------------------- ----------------------- -----------------------
  **Catégorie de          **Exemples**            **Finalité principale**
  données**                                       

  Données de compte       Nom, prénom, e-mail     Création et gestion du
  (Client)                professionnel,          compte,
                          téléphone, fonction,    authentification,
                          entreprise, mot de      facturation
                          passe (chiffré)         

  Données de prospection  Nom, coordonnées,       Permettre au Client de
  saisies par le Client   entreprise, historique  gérer sa prospection
                          d'échanges, notes et    commerciale (le Client
                          statut des prospects du reste responsable de
                          Client                  ces données)

  Données techniques      Adresse IP, type        Sécurité, prévention de
                          d'appareil, journaux    la fraude, amélioration
                          de connexion, données   du service
                          de navigation           

  Données de facturation  Coordonnées de          Gestion contractuelle
                          facturation, historique et comptable
                          des paiements           
  ----------------------- ----------------------- -----------------------

**4. Finalités du traitement**

Nous traitons ces données pour :

- Fournir, exploiter et sécuriser l'application ;

- Gérer les comptes Clients et Utilisateurs autorisés, ainsi que la facturation ;

- Permettre au Client de mener ses activités de prospection (stockage et traitement technique des données de prospects qu'il nous confie) ;

- Assurer le support technique et répondre aux demandes ;

- Améliorer nos services (statistiques d'usage agrégées et anonymisées) ;

- Respecter nos obligations légales et comptables.

Nous ne vendons pas vos données, ni celles de vos prospects, à des tiers à des fins commerciales.

**5. Base légale du traitement**

- L'exécution du contrat de licence pour les données de compte et de facturation ;

- L'intérêt légitime d'ECIN pour la sécurité, la prévention de la fraude et l'amélioration du service ;

- Les instructions contractuelles du Client, en sa qualité de responsable de traitement, pour les données de prospection ;

- Le respect d'obligations légales, le cas échéant (comptabilité, réquisitions judiciaires).

**6. Destinataires des données**

Les données sont accessibles :

- Aux membres habilités de l'équipe ECIN, dans la limite de leurs fonctions ;

- Aux prestataires techniques d'ECIN (hébergement, envoi d'e-mails transactionnels, outils de support), liés par des obligations de confidentialité et de sécurité contractuelles ;

- Aux autorités compétentes, si la loi l'exige.

Aucune donnée n'est cédée ou louée à des tiers à des fins de marketing sans votre consentement explicite, lorsque celui-ci est requis.

**7. Durée de conservation**

- Données de compte Client : pendant toute la durée du contrat de licence, puis archivées pendant la durée nécessaire au respect de nos obligations légales et comptables ;

- Données de prospection : conservées selon les instructions du Client et supprimées ou restituées dans un délai de [30] jours après la fin du contrat, sauf obligation légale contraire ;

- Données techniques / journaux : conservées [12] mois maximum, à des fins de sécurité.

**8. Sécurité des données**

ECIN met en œuvre des mesures techniques et organisationnelles raisonnables pour protéger les données contre l'accès non autorisé, la perte, l'altération ou la divulgation, notamment : chiffrement des mots de passe, contrôle des accès, sauvegardes régulières et hébergement sur une infrastructure sécurisée.

Aucun système n'étant infaillible, en cas d'incident de sécurité affectant des données à caractère personnel, ECIN s'engage à informer les personnes et autorités concernées dans les meilleurs délais et conformément à la réglementation applicable.

**9. Vos droits**

Sous réserve de la réglementation applicable (notamment la loi camerounaise relative à la cybersécurité et à la protection des données à caractère personnel, et le Règlement Général sur la Protection des Données pour les personnes situées dans l'Union européenne, le cas échéant), vous disposez des droits suivants :

  ----------------------------------- -----------------------------------
  **Droit**                           **Description**

  Droit d'accès                      Obtenir une copie des données vous
                                      concernant que nous détenons.

  Droit de rectification              Faire corriger des données
                                      inexactes ou incomplètes.

  Droit à l'effacement               Demander la suppression de vos
                                      données, sous réserve des
                                      obligations légales de
                                      conservation.

  Droit d'opposition                 Vous opposer, pour motif légitime,
                                      à un traitement de vos données.

  Droit à la portabilité              Recevoir vos données dans un format
                                      structuré et couramment utilisé.

  Droit de limitation                 Demander la limitation temporaire
                                      d'un traitement en cours de
                                      contestation.
  ----------------------------------- -----------------------------------

Pour exercer ces droits, contactez-nous à ecinumerique@gmail.com. Nous nous engageons à répondre dans un délai raisonnable, et au plus tard dans le délai prévu par la réglementation applicable.

**10. Transferts de données**

Vos données sont hébergées *[à préciser : au Cameroun / chez un fournisseur cloud et sa localisation, ex. Europe, Afrique]*. Si un transfert hors de votre pays de résidence est nécessaire, ECIN veille à ce que des garanties appropriées soient mises en place.

**11. Cookies et traceurs**

Si l'application est accessible via une interface web, elle peut utiliser des cookies strictement nécessaires à son fonctionnement (authentification, préférences) et, le cas échéant, des cookies de mesure d'audience. *[À compléter selon les cookies effectivement utilisés : nom, finalité, durée de conservation, et bannière de consentement le cas échéant.]*

**12. Mineurs**

L'application est destinée à un usage professionnel et n'est pas conçue pour être utilisée par des personnes mineures. ECIN ne collecte pas sciemment de données concernant des mineurs.

**13. Modifications de la présente politique**

Nous pouvons être amenés à modifier cette politique, notamment pour refléter une évolution du Logiciel ou de la réglementation. La version en vigueur est celle publiée dans l'application ou communiquée au Client, avec mention de sa date de mise à jour.

**14. Réclamations et contact**

Pour toute question ou réclamation relative à vos données :
**ecinumerique@gmail.com** --- +237 696 77 18 41.

Si vous estimez que vos droits ne sont pas respectés, vous disposez également de la faculté de saisir l'autorité de protection des données compétente.
  ''';
}