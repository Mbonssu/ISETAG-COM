# Corrections apportées à ISETAG_COM_API

L'app `authentification` n'a **pas été touchée** (elle reste débranchée
volontairement de `INSTALLED_APPS` et des urls).

## Bugs bloquants corrigés

1. **`RendezVousView.get(pk)` et `SuiviProspectView.get(pk)`** : `many=True`
   était appliqué à un objet unique → `AttributeError` garanti dès qu'on
   consultait le détail. Corrigé pour utiliser le serializer sans `many=True`
   en mode détail.
2. **`RelanceView`** : incomplète (ni `get(pk)`, ni `put`, ni `delete`) et
   jamais routée dans `prospect_api/urls.py` → aucune route `/relances/`
   n'existait. Complétée sur le modèle des autres vues et routée.
3. **`RendezVousSerializer.get_prospect_details`** et
   **`RelanceSerializer.get_prospect_details`** : `SerializerMethodField`
   déclaré sans la méthode correspondante → `AttributeError` à la sérialisation.
   Méthodes ajoutées.
4. **`interetSpecialiteSerializer.get_specialite_details` /
   `get_prospect_details`** : même bug, découvert en générant le schéma
   OpenAPI. Méthodes ajoutées.
5. **Mot de passe en clair** : `UtilisateurSerializer` ne hachait jamais le
   mot de passe (`create()`/`update()` ne faisaient pas appel à
   `set_password()`). Corrigé — le champ `password` est maintenant
   `write_only` et haché via `set_password()`.
6. **CORS bloquait tout** : `corsheaders` était installé mais sans
   `CORS_ALLOWED_ORIGINS` configuré (comportement par défaut = tout refuser).
   Ajout d'une configuration avec les origines Vite/React locales
   (`localhost:5173`, `localhost:3000`), surchargeable via
   `DJANGO_CORS_ALLOWED_ORIGINS`. `CorsMiddleware` repositionné avant
   `CommonMiddleware` (ordre recommandé par la doc django-cors-headers).
7. **`Participation.__str__`** référençait `idUtilisateur.nomComplet`, un
   champ inexistant sur `Utilisateur` (qui a `nom`/`prenom`). Corrigé.
8. **Import dupliqué** dans `specialite_api/models.py`. Supprimé.

## Sécurité / configuration

- `SECRET_KEY`, mot de passe PostgreSQL, `DEBUG`, `ALLOWED_HOSTS` sortis en
  variables d'environnement (`os.environ.get(...)`) avec les mêmes valeurs
  par défaut qu'avant — donc **le comportement ne change pas tant que
  vous ne créez pas de `.env`**. Voir `.env.example`.
- `TIME_ZONE` passé de `UTC` à `Africa/Douala`, `LANGUAGE_CODE` de `en-us`
  à `fr-fr`, pour cohérence avec le reste de vos projets.
- Ajout d'un `.gitignore` (absent du projet).
- Ajout d'un `requirements.txt` (absent du projet).

## Non modifié volontairement

- L'app `authentification` (models, serializers, views, permissions, urls,
  et son absence de `INSTALLED_APPS`).
- Les permissions commentées dans chaque vue (`get_permissions`) — elles
  dépendent de `authentification.permissions`, donc les réactiver sans
  authentification n'aurait pas de sens. Elles sont prêtes à être
  décommentées le jour où vous rebranchez l'auth.
- Les codes de retour DELETE (204 pour `campagne_api`/`user_api`, 200 avec
  message pour `prospect_api`/`specialite_api`) : incohérent mais je ne l'ai
  pas harmonisé pour ne pas casser un frontend déjà branché dessus. À
  uniformiser si vous voulez.
- Le passage à `ModelViewSet` + `DefaultRouter` (réduirait fortement la
  duplication de code) : pas fait, car c'est un refactor plus large que
  vous n'avez pas demandé.

## Documentation API (drf-spectacular)

Ajouté :
- `drf_spectacular` dans `INSTALLED_APPS`
- `DEFAULT_SCHEMA_CLASS` + `SPECTACULAR_SETTINGS` dans `settings.py`
- 3 routes dans `ISETAG_COM_API/urls.py` :
  - `/api/schema/` → schéma OpenAPI brut (YAML)
  - `/api/docs/` → Swagger UI interactif
  - `/api/redoc/` → Redoc (documentation statique lisible)
- `@extend_schema` / `@extend_schema_view` sur toutes les vues (14
  ressources, 28 endpoints), avec tags par domaine métier (Prospects,
  Rendez-vous, Campagnes, Zones, etc.) pour que Swagger regroupe les
  routes proprement.

Schéma généré et validé : **0 erreur**, quelques warnings cosmétiques
(collisions d'`operationId` entre la route liste et la route détail,
auto-résolues par drf-spectacular avec des suffixes numériques).

### Pour l'utiliser

```bash
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

Puis ouvrir `http://localhost:8000/api/docs/`.
