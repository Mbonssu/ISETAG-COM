from django.shortcuts import render
from .serializers import CampagneProspectionSerializer, ZoneSerializer, SortieSerializer, SourceSerializer, ParticipationSerializer, etablissementSerializer, ficheSortieSerializer
from .models import CampagneProspection, Etablissement, Zone, Sortie, source, Participation, ficheSortie
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.parsers import JSONParser, MultiPartParser, FormParser
from drf_spectacular.utils import extend_schema, extend_schema_view
# from .ws_utils import notify_service_created, notify_service_updated, notify_service_deleted
# from authentification.permissions import IsAdmin, IsSuperviseur,IsAgent


@extend_schema_view(
    get=extend_schema(tags=['Campagnes'], summary="Lister les campagnes de prospection", responses=CampagneProspectionSerializer(many=True)),
    post=extend_schema(tags=['Campagnes'], summary="Créer une campagne de prospection", request=CampagneProspectionSerializer, responses=CampagneProspectionSerializer),
    put=extend_schema(tags=['Campagnes'], summary="Mettre à jour une campagne de prospection", request=CampagneProspectionSerializer, responses=CampagneProspectionSerializer),
    delete=extend_schema(tags=['Campagnes'], summary="Supprimer une campagne de prospection", responses={204: None}),
)
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

    
    def get(self, request, pk=None):
        if pk is not None:
            try:
                campagne = CampagneProspection.objects.get(pk=pk)
                serializer = CampagneProspectionSerializer(campagne)
                return Response(serializer.data)
            except CampagneProspection.DoesNotExist:
                return Response(status=status.HTTP_404_NOT_FOUND)
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
    

@extend_schema_view(
    get=extend_schema(tags=['Zones'], summary="Lister les zones géographiques", responses=ZoneSerializer(many=True)),
    post=extend_schema(tags=['Zones'], summary="Créer une zone géographique", request=ZoneSerializer, responses=ZoneSerializer),
    put=extend_schema(tags=['Zones'], summary="Mettre à jour une zone géographique", request=ZoneSerializer, responses=ZoneSerializer),
    delete=extend_schema(tags=['Zones'], summary="Supprimer une zone géographique", responses={204: None}),
)
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
    
    def get(self, request, pk=None):
        if(pk):
            try:
                Zones = Zone.objects.filter(idZone=pk)
                serializer = ZoneSerializer(Zones, many=True)
                return Response(serializer.data)
            except Zone.DoesNotExist:
                return Response(status=status.HTTP_404_NOT_FOUND)
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
    

@extend_schema_view(
    get=extend_schema(tags=['Sorties'], summary="Lister les sorties terrain", responses=SortieSerializer(many=True)),
    post=extend_schema(tags=['Sorties'], summary="Créer une sortie terrain", request=SortieSerializer, responses=SortieSerializer),
    put=extend_schema(tags=['Sorties'], summary="Mettre à jour une sortie terrain", request=SortieSerializer, responses=SortieSerializer),
    delete=extend_schema(tags=['Sorties'], summary="Supprimer une sortie terrain", responses={204: None}),
)
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
    
    def get(self, request, pk=None):
        if pk is not None:
            try:
                sortie = Sortie.objects.get(pk=pk)
                serializer = SortieSerializer(sortie)
                return Response(serializer.data)
            except Sortie.DoesNotExist:
                return Response(status=status.HTTP_404_NOT_FOUND)
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


@extend_schema_view(
    get=extend_schema(tags=['Sources'], summary="Lister les sources de prospection", responses=SourceSerializer(many=True)),
    post=extend_schema(tags=['Sources'], summary="Créer une source de prospection", request=SourceSerializer, responses=SourceSerializer),
    put=extend_schema(tags=['Sources'], summary="Mettre à jour une source de prospection", request=SourceSerializer, responses=SourceSerializer),
    delete=extend_schema(tags=['Sources'], summary="Supprimer une source de prospection", responses={204: None}),
)
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
    
    def get(self, request, pk=None):
        if(pk):
            try:
                sources = source.objects.filter(idSource=pk)
            except source.DoesNotExist:
                return Response(status=status.HTTP_404_NOT_FOUND)
            serializer = SourceSerializer(sources, many=True)
            return Response(serializer.data)
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
    

@extend_schema_view(
    get=extend_schema(tags=['Participations'], summary="Lister les participations d'agents aux sorties", responses=ParticipationSerializer(many=True)),
    post=extend_schema(tags=['Participations'], summary="Créer une participation", request=ParticipationSerializer, responses=ParticipationSerializer),
    put=extend_schema(tags=['Participations'], summary="Mettre à jour une participation", request=ParticipationSerializer, responses=ParticipationSerializer),
    delete=extend_schema(tags=['Participations'], summary="Supprimer une participation", responses={204: None}),
)
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
    
    def get(self, request, pk=None):
        if pk is not None:
            try:
                participation_instance = Participation.objects.get(pk=pk)
                serializer = ParticipationSerializer(participation_instance)
                return Response(serializer.data)
            except Participation.DoesNotExist:
                return Response(status=status.HTTP_404_NOT_FOUND)
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


@extend_schema_view(
    get=extend_schema(tags=['Fiches de sortie'], summary="Lister les fiches de sortie", responses=ficheSortieSerializer(many=True)),
    post=extend_schema(tags=['Fiches de sortie'], summary="Créer une fiche de sortie", request=ficheSortieSerializer, responses=ficheSortieSerializer),
    put=extend_schema(tags=['Fiches de sortie'], summary="Mettre à jour une fiche de sortie", request=ficheSortieSerializer, responses=ficheSortieSerializer),
    delete=extend_schema(tags=['Fiches de sortie'], summary="Supprimer une fiche de sortie", responses={204: None}),
)
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
    
    def get(self, request, pk=None):
        if(pk):
            try:
                fiches = ficheSortie.objects.filter(idFiche=pk)
            except ficheSortie.DoesNotExist:
                return Response(status=status.HTTP_404_NOT_FOUND)
            serializer = ficheSortieSerializer(fiches, many=True)
            return Response(serializer.data)
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


@extend_schema_view(
    get=extend_schema(tags=['Établissements'], summary="Lister les établissements", responses=etablissementSerializer(many=True)),
    post=extend_schema(tags=['Établissements'], summary="Créer un établissement", request=etablissementSerializer, responses=etablissementSerializer),
    put=extend_schema(tags=['Établissements'], summary="Mettre à jour un établissement", request=etablissementSerializer, responses=etablissementSerializer),
    delete=extend_schema(tags=['Établissements'], summary="Supprimer un établissement", responses={204: None}),
)
class etablissementView(APIView):
    
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
    
    def get(self, request,pk=None):
        if pk is None:
            etablissements = Etablissement.objects.all()
        else:
            etablissements = Etablissement.objects.filter(pk=pk)

        serializer = etablissementSerializer(etablissements, many=True)
        return Response(serializer.data)
    
    def post(self, request):
        serializer = etablissementSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def put(self, request, pk):
        try:
            etablissement_instance = Etablissement.objects.get(pk=pk)
        except Etablissement.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        serializer = etablissementSerializer(etablissement_instance, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        try:
            etablissement_instance = Etablissement.objects.get(pk=pk)
        except Etablissement.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        etablissement_instance.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
