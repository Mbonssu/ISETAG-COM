from django.shortcuts import render
from .serializers import CampagneProspectionSerializer, ZoneSerializer, SortieSerializer, SourceSerializer, ParticipationSerializer, ficheSortieSerializer
from .models import CampagneProspection, Zone, Sortie, source, Participation, ficheSortie
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.parsers import JSONParser, MultiPartParser, FormParser
# from .ws_utils import notify_service_created, notify_service_updated, notify_service_deleted
# from authentification.permissions import IsAdmin, IsSuperviseur,IsAgent

class CampagneView(APIView):
    
    parser_classes = [JSONParser, MultiPartParser, FormParser]
    
    # def get_permissions(self):
    #     """
    #     Permissions différentes selon la méthode HTTP.
    #     """
    #     if self.request.method == 'GET':
    #         return [IsSuperviseur()]   # admins + superviseurs
    #     elif self.request.method == 'POST':
    #         return [IsAgent()]         # admins seulement
    #     elif self.request.method == 'PUT':
    #         return [IsAgent()]         # tous les rôles
    #     elif self.request.method == 'DELETE':
    #         return [IsAdmin()]         # admins seulement
    #     return [IsAdmin()]             # fallback sécurisé

    
    def get(self, request):
        campagnes = CampagneProspection.objects.all()
        serializer = CampagneProspectionSerializer(campagnes, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = CampagneProspectionSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk):
        try:
            campagne = CampagneProspection.objects.get(pk=pk)
        except CampagneProspection.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        serializer = CampagneProspectionSerializer(campagne, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk):
        try:
            campagne = CampagneProspection.objects.get(pk=pk)
        except CampagneProspection.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        campagne.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class ZoneView(APIView):
    
    parser_classes = [JSONParser, MultiPartParser, FormParser]
    
    # def get_permissions(self):
    #     """
    #     Permissions différentes selon la méthode HTTP.
    #     """
    #     if self.request.method == 'GET':
    #         return [IsSuperviseur()]   # admins + superviseurs
    #     elif self.request.method == 'POST':
    #         return [IsAgent()]         # admins seulement
    #     elif self.request.method == 'PUT':
    #         return [IsAgent()]         # tous les rôles
    #     elif self.request.method == 'DELETE':
    #         return [IsAdmin()]         # admins seulement
    #     return [IsAdmin()]             # fallback sécurisé
    
    def get(self, request):
        zones = Zone.objects.all()
        serializer = ZoneSerializer(zones, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = ZoneSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk):
        try:
            zone = Zone.objects.get(pk=pk)
        except Zone.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        serializer = ZoneSerializer(zone, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk):
        try:
            zone = Zone.objects.get(pk=pk)
        except Zone.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        zone.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class SortieView(APIView):
        
    parser_classes = [JSONParser, MultiPartParser, FormParser]
    
    # def get_permissions(self):
    #     """
    #     Permissions différentes selon la méthode HTTP.
    #     """
    #     if self.request.method == 'GET':
    #         return [IsSuperviseur()]   # admins + superviseurs
    #     elif self.request.method == 'POST':
    #         return [IsAgent()]         # admins seulement
    #     elif self.request.method == 'PUT':
    #         return [IsAgent()]         # tous les rôles
    #     elif self.request.method == 'DELETE':
    #         return [IsAdmin()]         # admins seulement
    #     return [IsAdmin()]             # fallback sécurisé
    
    def get(self, request):
        sorties = Sortie.objects.all()
        serializer = SortieSerializer(sorties, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = SortieSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk):
        try:
            sortie = Sortie.objects.get(pk=pk)
        except Sortie.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        serializer = SortieSerializer(sortie, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk):
        try:
            sortie = Sortie.objects.get(pk=pk)
        except Sortie.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        sortie.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class SourceView(APIView):
        
    parser_classes = [JSONParser, MultiPartParser, FormParser]
    
    # def get_permissions(self):
    #     """
    #     Permissions différentes selon la méthode HTTP.
    #     """
    #     if self.request.method == 'GET':
    #         return [IsSuperviseur()]   # admins + superviseurs
    #     elif self.request.method == 'POST':
    #         return [IsAgent()]         # admins seulement
    #     elif self.request.method == 'PUT':
    #         return [IsAgent()]         # tous les rôles
    #     elif self.request.method == 'DELETE':
    #         return [IsAdmin()]         # admins seulement
    #     return [IsAdmin()]             # fallback sécurisé
    
    def get(self, request):
        sources = source.objects.all()
        serializer = SourceSerializer(sources, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = SourceSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk):
        try:
            source_instance = source.objects.get(pk=pk)
        except source.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        serializer = SourceSerializer(source_instance, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk):
        try:
            source_instance = source.objects.get(pk=pk)
        except source.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        source_instance.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class ParticipationView(APIView):
        
    parser_classes = [JSONParser, MultiPartParser, FormParser]
    
    # def get_permissions(self):
    #     """
    #     Permissions différentes selon la méthode HTTP.
    #     """
    #     if self.request.method == 'GET':
    #         return [IsSuperviseur()]   # admins + superviseurs
    #     elif self.request.method == 'POST':
    #         return [IsAgent()]         # admins seulement
    #     elif self.request.method == 'PUT':
    #         return [IsAgent()]         # tous les rôles
    #     elif self.request.method == 'DELETE':
    #         return [IsAdmin()]         # admins seulement
    #     return [IsAdmin()]             # fallback sécurisé
    
    def get(self, request):
        participations = Participation.objects.all()
        serializer = ParticipationSerializer(participations, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = ParticipationSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk):
        try:
            participation_instance = Participation.objects.get(pk=pk)
        except Participation.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        serializer = ParticipationSerializer(participation_instance, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk):
        try:
            participation_instance = Participation.objects.get(pk=pk)
        except Participation.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        participation_instance.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class ficheSortieView(APIView):
        
    parser_classes = [JSONParser, MultiPartParser, FormParser]
    
    # def get_permissions(self):
    #     """
    #     Permissions différentes selon la méthode HTTP.
    #     """
    #     if self.request.method == 'GET':
    #         return [IsSuperviseur()]   # admins + superviseurs
    #     elif self.request.method == 'POST':
    #         return [IsAgent()]         # admins seulement
    #     elif self.request.method == 'PUT':
    #         return [IsAgent()]         # tous les rôles
    #     elif self.request.method == 'DELETE':
    #         return [IsAdmin()]         # admins seulement
    #     return [IsAdmin()]             # fallback sécurisé
    
    def get(self, request):
        fiches = ficheSortie.objects.all()
        serializer = ficheSortieSerializer(fiches, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = ficheSortieSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk):
        try:
            fiche_instance = ficheSortie.objects.get(pk=pk)
        except ficheSortie.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        serializer = ficheSortieSerializer(fiche_instance, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk):
        try:
            fiche_instance = ficheSortie.objects.get(pk=pk)
        except ficheSortie.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        fiche_instance.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)