from rest_framework import serializers
from .models import Utilisateur
import uuid

class UtilisateurSerializer(serializers.ModelSerializer):
    
    photoProfil = serializers.SerializerMethodField()

    def get_photoProfil(self, obj):
        if obj.photoProfil and obj.photoProfil.name:
            request = self.context.get('request')
            if request:
                return request.build_absolute_uri(obj.photoProfil.url)
            return obj.photoProfil.url
        return None
    
    class Meta:
        model = Utilisateur
        fields = '__all__'
    
    # On génère le code ici avant la sauvegarde
    def create(self, validated_data):
        validated_data['idUtilisateur'] = f"APP-{uuid.uuid4().hex[:8].upper()}"
        return super().create(validated_data)