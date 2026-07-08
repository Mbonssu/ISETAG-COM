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
from drf_spectacular.utils import extend_schema, extend_schema_view, OpenApiParameter
# from .ws_utils import notify_service_created, notify_service_updated, notify_service_deleted

@extend_schema_view(
    get=extend_schema(
        tags=['Prospects'],
        summary="Lister les prospects ou récupérer un prospect par pk",
        parameters=[OpenApiParameter(name='pk', location=OpenApiParameter.PATH, required=False, type=str, description="Identifiant du prospect")],
        responses=ProspectSerializer(many=True),
    ),
    post=extend_schema(tags=['Prospects'], summary="Créer un prospect", request=ProspectSerializer, responses=ProspectSerializer),
    put=extend_schema(tags=['Prospects'], summary="Mettre à jour un prospect", request=ProspectSerializer, responses=ProspectSerializer),
    delete=extend_schema(tags=['Prospects'], summary="Supprimer un prospect", responses={200: None}),
)
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
    
@extend_schema_view(
    get=extend_schema(
        tags=['Rendez-vous'],
        summary="Lister les rendez-vous ou récupérer un rendez-vous par pk",
        parameters=[OpenApiParameter(name='pk', location=OpenApiParameter.PATH, required=False, type=str, description="Identifiant du rendez-vous")],
        responses=RendezVousSerializer(many=True),
    ),
    post=extend_schema(tags=['Rendez-vous'], summary="Créer un rendez-vous", request=RendezVousSerializer, responses=RendezVousSerializer),
    put=extend_schema(tags=['Rendez-vous'], summary="Mettre à jour un rendez-vous", request=RendezVousSerializer, responses=RendezVousSerializer),
    delete=extend_schema(tags=['Rendez-vous'], summary="Supprimer un rendez-vous", responses={200: None}),
)
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
            serializer = RendezVousSerializer(rendezvous, many=True, context={'request': request})
            return Response(serializer.data)

        try:
            rendezvous = RendezVous.objects.get(pk=pk)
        except RendezVous.DoesNotExist:
            return Response({'error': 'Rendez-vous not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = RendezVousSerializer(rendezvous, context={'request': request})
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
    
@extend_schema_view(
    get=extend_schema(
        tags=['Suivis Prospect'],
        summary="Lister les suivis ou récupérer un suivi par pk",
        parameters=[OpenApiParameter(name='pk', location=OpenApiParameter.PATH, required=False, type=str, description="Identifiant du suivi")],
        responses=SuiviProspectSerializer(many=True),
    ),
    post=extend_schema(tags=['Suivis Prospect'], summary="Créer un suivi de prospect", request=SuiviProspectSerializer, responses=SuiviProspectSerializer),
    put=extend_schema(tags=['Suivis Prospect'], summary="Mettre à jour un suivi de prospect", request=SuiviProspectSerializer, responses=SuiviProspectSerializer),
    delete=extend_schema(tags=['Suivis Prospect'], summary="Supprimer un suivi de prospect", responses={200: None}),
)
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
            serializer = SuiviProspectSerializer(suivis, many=True, context={'request': request})
            return Response(serializer.data)

        try:
            suivi = SuiviProspect.objects.get(pk=pk)
        except SuiviProspect.DoesNotExist:
            return Response({'error': 'Suivi not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = SuiviProspectSerializer(suivi, context={'request': request})
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

@extend_schema_view(
    get=extend_schema(
        tags=['Relances'],
        summary="Lister les relances ou récupérer une relance par pk",
        parameters=[OpenApiParameter(name='pk', location=OpenApiParameter.PATH, required=False, type=str, description="Identifiant de la relance")],
        responses=RelanceSerializer(many=True),
    ),
    post=extend_schema(tags=['Relances'], summary="Créer une relance", request=RelanceSerializer, responses=RelanceSerializer),
    put=extend_schema(tags=['Relances'], summary="Mettre à jour une relance", request=RelanceSerializer, responses=RelanceSerializer),
    delete=extend_schema(tags=['Relances'], summary="Supprimer une relance", responses={200: None}),
)
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

    def get(self, request, pk=None):
        if pk is None:
            relances = Relance.objects.all()
            serializer = RelanceSerializer(relances, many=True, context={'request': request})
            return Response(serializer.data)

        try:
            relance = Relance.objects.get(pk=pk)
        except Relance.DoesNotExist:
            return Response({'error': 'Relance not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = RelanceSerializer(relance, context={'request': request})
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

    def put(self, request, pk):
        try:
            relance = Relance.objects.get(pk=pk)
        except Relance.DoesNotExist:
            return Response({'error': 'Relance not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = RelanceSerializer(relance, data=request.data, context={'request': request})
        if serializer.is_valid():
            try:
                serializer.save()
                # notify_service_updated(relance)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except IntegrityError:
                return Response({"error": "Une relance avec ce sujet existe déjà."}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        try:
            relance = Relance.objects.get(pk=pk)
        except Relance.DoesNotExist:
            return Response({'error': 'Relance not found'}, status=status.HTTP_404_NOT_FOUND)

        relance.delete()
        return Response({'message': 'Relance deleted successfully'}, status=status.HTTP_200_OK)