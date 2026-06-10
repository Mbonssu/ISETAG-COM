from rest_framework import serializers
from .models import Prospect, Relance, RendezVous, SuiviProspect
import uuid

class ProspectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Prospect
        fields = '__all__'
    
    # On génère le code ici avant la sauvegarde
    def create(self, validated_data):
        validated_data['idProspect'] = f"PROS-{uuid.uuid4().hex[:8].upper()}"
        return super().create(validated_data)

class RendezVousSerializer(serializers.ModelSerializer):
    idProspect = serializers.PrimaryKeyRelatedField(queryset=Prospect.objects.all())
    
    prospect_details = serializers.SerializerMethodField(read_only=True)
    
    class Meta:
        model = RendezVous
        fields = '__all__'
    
    # On génère le code ici avant la sauvegarde
    def create(self, validated_data):
        validated_data['idRendezVous'] = f"RDV-{uuid.uuid4().hex[:8].upper()}"
        return super().create(validated_data)
    
class SuiviProspectSerializer(serializers.ModelSerializer):
    idProspect = serializers.PrimaryKeyRelatedField(queryset=Prospect.objects.all())
    prospect_details = serializers.SerializerMethodField(read_only=True)
    class Meta:
        model = SuiviProspect
        fields = '__all__'
    
    # On génère le code ici avant la sauvegarde
    def create(self, validated_data):
        validated_data['idSuivi'] = f"SUIVI-{uuid.uuid4().hex[:8].upper()}"
        return super().create(validated_data)
    
class RelanceSerializer(serializers.ModelSerializer):
    idProspect = serializers.PrimaryKeyRelatedField(queryset=Prospect.objects.all())
    prospect_details = serializers.SerializerMethodField(read_only=True)
    class Meta:
        model = Relance
        fields = '__all__'
    
    # On génère le code ici avant la sauvegarde
    def create(self, validated_data):
        validated_data['idRelance'] = f"REL-{uuid.uuid4().hex[:8].upper()}"
        return super().create(validated_data)