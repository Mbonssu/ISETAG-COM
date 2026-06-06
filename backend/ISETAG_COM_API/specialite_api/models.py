from django.db import models

from django.db import models
from prospect_api.models import *

class Specialite(models.Model):
    idSpecialite = models.CharField(max_length=25, primary_key=True)
    libeleSpecialite = models.CharField(max_length=200)
    description = models.TextField()
    createdAt = models.DateTimeField(auto_now_add=True)
    updatedAt = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'specialite'

    def __str__(self):
        return self.libeleSpecialite

class interetSpecialite(models.Model):
    idInteret = models.CharField(max_length=25, primary_key=True)
    idSpecialite = models.ForeignKey(Specialite, on_delete=models.CASCADE)
    idProspect = models.ForeignKey(Prospect, on_delete=models.CASCADE)
    niveauInteret = models.CharField(max_length=50)
    createdAt = models.DateTimeField(auto_now_add=True)
    updatedAt = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'interetspecialite'

    def __str__(self):
        return self.niveauInteret