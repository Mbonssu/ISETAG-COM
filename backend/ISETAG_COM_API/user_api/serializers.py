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
        extra_kwargs = {
            'password': {'write_only': True, 'required': False},
        }
    
    # On génère le code ici avant la sauvegarde, et on hache le mot de passe
    # (avant : le mot de passe etait sauvegarde en clair, sans set_password())
    def create(self, validated_data):
        validated_data['idUtilisateur'] = f"APP-{uuid.uuid4().hex[:8].upper()}"
        password = validated_data.pop('password', None)
        utilisateur = Utilisateur(**validated_data)
        if password:
            utilisateur.set_password(password)
        else:
            utilisateur.set_unusable_password()
        utilisateur.save()
        return utilisateur

    def update(self, instance, validated_data):
        password = validated_data.pop('password', None)
        instance = super().update(instance, validated_data)
        if password:
            instance.set_password(password)
            instance.save()
        return instance