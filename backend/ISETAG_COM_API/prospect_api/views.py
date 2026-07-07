from django.shortcuts import render
# from authentification.permissions import IsAdmin, IsSuperviseur,IsAgent
# from backend.ISETAG_COM_API.user_api.models import Utilisateur
# from backend.ISETAG_COM_API.user_api.serializers import UtilisateurSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.db import IntegrityError
from .models import Prospect, RendezVous, SuiviProspect, Relance
from .serializers import ProspectSerializer, RelanceSerializer, RendezVousSerializer, SuiviProspectSerializer
from rest_framework.parsers import JSONParser, MultiPartParser, FormParser
# from .ws_utils import notify_service_created, notify_service_updated, notify_service_deleted

class ProspectView(APIView):
    parser_classes = [JSONParser, MultiPartParser, FormParser]
    
    # def get_permissions(self):
    #     """
    #     Permissions différentes selon la méthode HTTP.
    #     """
    #     if self.request.method == 'GET':
    #         return [IsSuperviseur()]   # admins + superviseurs
    #     elif self.request.method == 'POST':
    #         return [IsAdmin()]         # admins seulement
    #     elif self.request.method == 'PUT':
    #         return [IsAgent()]         # tous les rôles
    #     elif self.request.method == 'DELETE':
    #         return [IsAdmin()]         # admins seulement
    #     return [IsAdmin()]             # fallback sécurisé

    def get(self, request, pk=None):
        if pk:
            try:
                prospect = Prospect.objects.get(pk=pk)
                serializer = ProspectSerializer(prospect, context={'request': request})
                return Response(serializer.data, status=status.HTTP_200_OK)
            except Prospect.DoesNotExist:
                return Response({'error': 'Prospect not found'}, status=status.HTTP_404_NOT_FOUND)
        prospects = Prospect.objects.all()
        serializer = ProspectSerializer(prospects, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request):
        serializer = ProspectSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            try:
                serializer.save()
                # notify_service_created(prospect)
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            except IntegrityError:
                return Response({"error": "Un prospect avec cet email existe déjà."}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def put(self, request, pk):
        try:
            prospect = Prospect.objects.get(pk=pk)
        except Prospect.DoesNotExist:
            return Response({'error': 'Prospect not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = ProspectSerializer(prospect, data=request.data, context={'request': request})
        if serializer.is_valid():
            try:
                serializer.save()
                # notify_service_updated(prospect)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except IntegrityError:
                return Response({"error": "Un prospect avec cet email existe déjà."}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk):
        try:
            prospect = Prospect.objects.get(pk=pk)
        except Prospect.DoesNotExist:
            return Response({'error': 'Prospect not found'}, status=status.HTTP_404_NOT_FOUND)

        prospect.delete()
        return Response({'message': 'Prospect deleted successfully'}, status=status.HTTP_200_OK)
    
class RendezVousView(APIView):
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

    def get(self, request, pk=None):
        if pk is None:
            rendezvous = RendezVous.objects.all()
        else:
            try:
                rendezvous = RendezVous.objects.get(pk=pk)
            except RendezVous.DoesNotExist:
                return Response({'error': 'Rendez-vous not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = RendezVousSerializer(rendezvous, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request):
        serializer = RendezVousSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            try:
                serializer.save()
                # notify_service_created(rendezvous)
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            except IntegrityError:
                return Response({"error": "Un rendez-vous avec ce sujet existe déjà."}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def put(self, request, pk):
        try:
            rendezvous = RendezVous.objects.get(pk=pk)
        except RendezVous.DoesNotExist:
            return Response({'error': 'Rendez-vous not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = RendezVousSerializer(rendezvous, data=request.data, context={'request': request})
        if serializer.is_valid():
            try:
                serializer.save()
                # notify_service_updated(rendezvous)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except IntegrityError:
                return Response({"error": "Un rendez-vous avec ce sujet existe déjà."}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk):
        try:
            rendezvous = RendezVous.objects.get(pk=pk)
        except RendezVous.DoesNotExist:
            return Response({'error': 'Rendez-vous not found'}, status=status.HTTP_404_NOT_FOUND)

        rendezvous.delete()
        return Response({'message': 'Rendez-vous deleted successfully'}, status=status.HTTP_200_OK)
    
class SuiviProspectView(APIView):
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

    def get(self, request, pk=None):
        if pk is None:
            suivis = SuiviProspect.objects.all()
        else:
            try:
                suivis = SuiviProspect.objects.get(pk=pk)
            except SuiviProspect.DoesNotExist:
                return Response({'error': 'Suivi not found'}, status=status.HTTP_404_NOT_FOUND)
        serializer = SuiviProspectSerializer(suivis, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request):
        serializer = SuiviProspectSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            try:
                serializer.save()
                # notify_service_created(suivi)
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            except IntegrityError:
                return Response({"error": "Un suivi avec ce libellé existe déjà."}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def put(self, request, pk):
        try:
            suivi = SuiviProspect.objects.get(pk=pk)
        except SuiviProspect.DoesNotExist:
            return Response({'error': 'Suivi not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = SuiviProspectSerializer(suivi, data=request.data, context={'request': request})
        if serializer.is_valid():
            try:
                serializer.save()
                # notify_service_updated(suivi)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except IntegrityError:
                return Response({"error": "Un suivi avec ce libellé existe déjà."}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk):
        try:
            suivi = SuiviProspect.objects.get(pk=pk)
        except SuiviProspect.DoesNotExist:
            return Response({'error': 'Suivi not found'}, status=status.HTTP_404_NOT_FOUND)

        suivi.delete()
        return Response({'message': 'Suivi deleted successfully'}, status=status.HTTP_200_OK)

class RelanceView(APIView):
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
        relances = Relance.objects.all()
        serializer = RelanceSerializer(relances, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request):
        serializer = RelanceSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            try:
                serializer.save()
                # notify_service_created(relance)
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            except IntegrityError:
                return Response({"error": "Une relance avec ce sujet existe déjà."}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)