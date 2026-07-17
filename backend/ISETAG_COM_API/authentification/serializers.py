from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class CustomTokenSerializer(TokenObtainPairSerializer):

    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)

        # Claims personnalisés — tout est en champ direct sur Utilisateur
        token['idUtilisateur']      = user.idUtilisateur
        token['nom']                = user.nom
        token['prenom']             = user.prenom
        token['email']              = user.email
        token['role']               = user.role
        token['statut']             = user.statut
        token['is_staff']           = user.is_staff
        token['telephone']          = user.telephone
        token['actif']              = user.actif
        token['dateEmbauche']       = user.dateEmbauche

        return token