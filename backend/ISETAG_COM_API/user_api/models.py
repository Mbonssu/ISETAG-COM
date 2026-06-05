from django.db import models
from django.utils import timezone
from django.contrib.auth.models import AbstractUser

class Utilisateur(AbstractUser):
    idUtilisateur = models.CharField(max_length=50, primary_key=True)
    nom = models.CharField(max_length=100, null=False, blank=False)
    prenom = models.CharField(max_length=100, null=False, blank=False, default="")
    telephone = models.CharField(max_length=100, null=False, blank=False)
    email = models.EmailField(max_length=254, null=False, blank=False, default="")
    role = models.CharField(max_length=25, null=False, blank=False)
    statut = models.CharField(max_length=25, null=False, blank=False)
    actif = models.BooleanField(default=True)
    dateEmbauche = models.DateField(null=True, blank=True)
    photoProfil = models.ImageField(upload_to='profile_pictures/', null=True, blank=True)
    createdAt = models.DateTimeField(default=timezone.now)
    
    class Meta :
        db_table = 'Utilisateur'

    def __str__(self):
        return f"{self.nom} {self.prenom}"