from django.db import models
from user_api.models import Utilisateur
# from campagne_api.models import Campagne

class Prospect(models.Model):
    idProspect = models.CharField(max_length=25, primary_key=True)
    nomComplet = models.CharField(max_length=200)
    email = models.EmailField(max_length=254)
    telephone = models.CharField(max_length=20)
    adresse = models.CharField(max_length=255)
    ville = models.CharField(max_length=100)
    codePostal = models.CharField(max_length=20)
    pays = models.CharField(max_length=100)
    sexe = models.CharField(max_length=10)
    dateNaissance = models.DateField(null = True, blank = True)
    niveauEtude = models.CharField(max_length=100)
    domaineEtude = models.CharField(max_length=100)
    typeProspect = models.CharField(max_length=50)
    nomParent = models.CharField(max_length=200, null = True, blank = True)
    numeroParent = models.CharField(max_length=20, null = True, blank = True)
    createdAt = models.DateTimeField(auto_now_add=True)
    updatedAt = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'prospect'
        
    def __str__(self):
        return self.nomComplet
    
class RendezVous(models.Model):
    idRendezVous = models.CharField(max_length=25, primary_key=True)
    idProspect = models.ForeignKey('Prospect', on_delete=models.CASCADE)
    dateRendezVous = models.DateTimeField()
    sujet = models.CharField(max_length=255)
    description = models.TextField()
    createdAt = models.DateTimeField(auto_now_add=True)
    updatedAt = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'rendezvous'
        
    def __str__(self):
        return self.sujet
    
class SuiviProspect(models.Model):
    idSuivi = models.CharField(max_length=25, primary_key=True)
    idProspect = models.ForeignKey('Prospect', on_delete=models.CASCADE)
    libeleSuivi = models.CharField(max_length=255, null = False, blank = False, default = "Nouveau suivi")
    dateSuivi = models.DateTimeField()
    commentaire = models.TextField()
    createdAt = models.DateTimeField(auto_now_add=True)
    updatedAt = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'suiviprospect'
        
    def __str__(self):
        return self.commentaire

class Relance(models.Model):
    idRelance = models.CharField(max_length=25, primary_key=True)
    idProspect = models.ForeignKey('Prospect', on_delete=models.CASCADE)
    dateRelance = models.DateTimeField()
    sujet = models.CharField(max_length=255)
    description = models.TextField()
    createdAt = models.DateTimeField(auto_now_add=True)
    updatedAt = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'relance'
        
    def __str__(self):
        return self.sujet