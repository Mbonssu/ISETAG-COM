from django.db import models
from prospect_api.models import *
from user_api.models import *

class CampagneProspection(models.Model):
    idCampagne = models.CharField(max_length=25, primary_key=True)
    libele = models.CharField(max_length=200)
    description = models.TextField()
    dateDebut = models.DateTimeField()
    dateFin = models.DateTimeField()
    objectif = models.CharField(max_length=255)
    type = models.CharField(max_length=50)
    createdAt = models.DateTimeField(auto_now_add=True)
    updatedAt = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'campagneprospect'
        
    def __str__(self):
        return self.libele

class Zone(models.Model):
    idZone = models.CharField(max_length=25, primary_key=True)
    libele = models.CharField(max_length=200)
    description = models.TextField()
    quartier = models.CharField(max_length=100)
    ville = models.CharField(max_length=100)
    pays = models.CharField(max_length=100)
    region = models.CharField(max_length=100)
    lieuDepart = models.CharField(max_length=100)
    lieuArrivee = models.CharField(max_length=100)
    createdAt = models.DateTimeField(auto_now_add=True)
    updatedAt = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'zone'
        
    def __str__(self):
        return self.quartier

class Sortie(models.Model):
    idSortie = models.CharField(max_length=25, primary_key=True)
    idZone = models.ForeignKey(Zone, on_delete=models.CASCADE)
    idCampagne = models.ForeignKey(CampagneProspection, on_delete=models.CASCADE)
    dateSortie = models.DateTimeField()
    statut = models.CharField(max_length=50)
    typeSortie = models.CharField(max_length=50)
    objectif = models.CharField(max_length=255)
    commentaire = models.TextField()
    createdAt = models.DateTimeField(auto_now_add=True)
    updatedAt = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'sortie'
        
    def __str__(self):
        return self.statut
    
class participation(models.Model):
    idParticipation = models.CharField(max_length=25, primary_key=True)
    idSortie = models.ForeignKey(Sortie, on_delete=models.CASCADE)
    idUtilisateur = models.ForeignKey(Utilisateur, on_delete=models.CASCADE)
    dateAssignation = models.CharField(max_length=50)
    heureArrivee = models.CharField(max_length=50)
    heureDepart = models.TimeField()
    statut = models.CharField(max_length=50)
    observation = models.TextField()
    createdAt = models.DateTimeField(auto_now_add=True)
    updatedAt = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'participation'
        
    def __str__(self):
        return f"{self.statut} {self.idUtilisateur.nomComplet}"