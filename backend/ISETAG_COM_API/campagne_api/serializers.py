from .models import CampagneProspection, Sortie, Zone, source, Participation, ficheSortie
from prospect_api.models import Prospect
from user_api.models import Utilisateur
from user_api.serializers import UtilisateurSerializer
from prospect_api.serializers import ProspectSerializer
from rest_framework import serializers

#Serializer des donnees de la classe CampagneProspection (pour GET, POST, PUT, DELETE)
#Dans les serializer les donnees sont automatiquement converties en JSON et inversement
class CampagneProspectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = CampagneProspection
        fields = '__all__'

#Serializer des donnees de la classe Zone (pour GET, POST, PUT, DELETE)
class ZoneSerializer(serializers.ModelSerializer):
    class Meta:
        model = Zone
        fields = '__all__'

#Serializer des donnees de la classe Sortie (pour GET, POST, PUT, DELETE)
class SortieSerializer(serializers.ModelSerializer):
    
    #champs de clé étrangère pour les relations avec les autres modèles et recuperer automatiquement les details de ces relations
    idZone = serializers.PrimaryKeyRelatedField(
        queryset=Zone.objects.all()
    )
    
    idCampagne = serializers.PrimaryKeyRelatedField(
        queryset=CampagneProspection.objects.all()
    )
    
    #passage des details de la zone et de la campagne dans le serializer pour les inclure dans les réponses API
    campagne_detail = CampagneProspectionSerializer(source='idCampagne', read_only=True)
    zone_detail = ZoneSerializer(source='idZone', read_only=True)

    class Meta:
        model = Sortie
        fields = '__all__'

#Serializer des donnees de la classe Source (pour GET, POST, PUT, DELETE)
class SourceSerializer(serializers.ModelSerializer):
    class Meta:
        model = source
        fields = '__all__'
        
#Serializer des donnees de la classe Participation (pour GET, POST, PUT, DELETE)
class ParticipationSerializer(serializers.ModelSerializer):
    # Champs de clé étrangère pour les relations avec les autres modèles et recuperer automatiquement les details de ces relations
    idUtilisateur = serializers.PrimaryKeyRelatedField(
        queryset=Utilisateur.objects.all()
    )
    
    idSortie = serializers.PrimaryKeyRelatedField(
        queryset=Sortie.objects.all()
    )
    
    #passage des details de l'utilisateur et de la sortie dans le serializer pour les inclure dans les réponses API
    utilisateur_detail = UtilisateurSerializer(source='idUtilisateur', read_only=True)
    sortie_detail = SortieSerializer(source='idSortie', read_only=True)

    class Meta:
        model = Participation
        fields = '__all__'

#Serializer des donnees de la classe ficheSortie (pour GET, POST, PUT, DELETE)
class ficheSortieSerializer(serializers.ModelSerializer):
    
    # Champs de clé étrangère pour les relations avec les autres modèles et recuperer automatiquement les details de ces relations
    idParticipation = serializers.PrimaryKeyRelatedField(
        queryset=Participation.objects.all()
    )
    
    idProspect = serializers.PrimaryKeyRelatedField(
        queryset=Prospect.objects.all()
    )
    
    idSource = serializers.PrimaryKeyRelatedField(
        queryset=source.objects.all()
    )
    
    #passage des details de la participation, du prospect et de la source dans le serializer pour les inclure dans les réponses API
    participation_detail = ParticipationSerializer(source='idParticipation', read_only=True)
    prospect_detail = ProspectSerializer(source='idProspect', read_only=True)
    source_detail = SourceSerializer(source='idSource', read_only=True)

    class Meta:
        model = ficheSortie
        fields = '__all__'