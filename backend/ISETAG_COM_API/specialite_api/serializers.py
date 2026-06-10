import uuid
from rest_framework import serializers
from .models import Specialite, interetSpecialite
from prospect_api.models import Prospect

class SpecialiteSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = Specialite
        fields = '__all__'
    
    # On génère le code ici avant la sauvegarde
    def create(self, validated_data):
        validated_data['idSpecialite'] = f"SPE-{uuid.uuid4().hex[:8].upper()}"
        return super().create(validated_data)

class interetSpecialiteSerializer(serializers.ModelSerializer):
    
    idSpecialite = serializers.PrimaryKeyRelatedField(queryset=Specialite.objects.all())
    specialite_details = serializers.SerializerMethodField(read_only=True)
    
    idProspect = serializers.PrimaryKeyRelatedField(queryset=Prospect.objects.all())
    prospect_details = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model = interetSpecialite
        fields = '__all__'
    
    # On génère le code ici avant la sauvegarde
    def create(self, validated_data):
        validated_data['idInteret'] = f"INT-{uuid.uuid4().hex[:8].upper()}"
        return super().create(validated_data)