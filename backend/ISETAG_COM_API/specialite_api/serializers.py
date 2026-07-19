import uuid
from rest_framework import serializers
from .models import Specialite, interetSpecialite
from prospect_api.models import Prospect
from drf_spectacular.utils import extend_schema_field
from drf_spectacular.types import OpenApiTypes

class SpecialiteSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = Specialite
        fields = '__all__'
    
    # On génère le code ici avant la sauvegarde
    #def create(self, validated_data):
        #validated_data['idSpecialite'] = f"SPE-{uuid.uuid4().hex[:8].upper()}"
        #return super().create(validated_data)

class interetSpecialiteSerializer(serializers.ModelSerializer):
    
    idSpecialite = serializers.PrimaryKeyRelatedField(queryset=Specialite.objects.all())
    specialite_details = serializers.SerializerMethodField(read_only=True)
    
    # idProspect = serializers.PrimaryKeyRelatedField(queryset=Prospect.objects.all())
    # prospect_details = serializers.SerializerMethodField(read_only=True)

    @extend_schema_field(OpenApiTypes.OBJECT)
    def get_specialite_details(self, obj):
        return {
            "idSpecialite": obj.idSpecialite.idSpecialite,
            "libeleSpecialite": obj.idSpecialite.libeleSpecialite,
            "acronyme": obj.idSpecialite.acronyme,
        }

    @extend_schema_field(OpenApiTypes.OBJECT)
    def get_prospect_details(self, obj):
        return {
            "idProspect": obj.idProspect.idProspect,
            "nom": obj.idProspect.nomComplet
        }

    class Meta:
        model = interetSpecialite
        fields = '__all__'
    
    # On génère le code ici avant la sauvegarde
    def create(self, validated_data):
        validated_data['idInteret'] = f"INT-{uuid.uuid4().hex[:8].upper()}"
        return super().create(validated_data)