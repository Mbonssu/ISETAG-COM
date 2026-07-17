from django.shortcuts import render

from .models import Specialite, interetSpecialite
from rest_framework.views import APIView
from rest_framework.response import Response
from .serializers import SpecialiteSerializer, interetSpecialiteSerializer
from rest_framework.parsers import JSONParser, MultiPartParser, FormParser
from drf_spectacular.utils import extend_schema, extend_schema_view
# from .ws_utils import notify_service_created, notify_service_updated, notify_service_deleted
from authentification.permissions import IsAdmin, IsSuperviseur,IsAgent


@extend_schema_view(
    get=extend_schema(tags=['Spécialités'], summary="Lister les spécialités (filières)", responses=SpecialiteSerializer(many=True)),
    post=extend_schema(tags=['Spécialités'], summary="Créer une spécialité", request=SpecialiteSerializer, responses=SpecialiteSerializer),
    put=extend_schema(tags=['Spécialités'], summary="Mettre à jour une spécialité", request=SpecialiteSerializer, responses=SpecialiteSerializer),
    delete=extend_schema(tags=['Spécialités'], summary="Supprimer une spécialité", responses={200: None}),
)
class SpecialiteView(APIView):
    parser_classes = [JSONParser, MultiPartParser, FormParser]

    def get_permissions(self):
        """
        Permissions différentes selon la méthode HTTP.
        """
        if self.request.method == 'GET':
            return [IsAgent()]   # admins + superviseurs
        elif self.request.method == 'POST':
            return [IsAdmin()]         # admins seulement
        elif self.request.method == 'PUT':
            return [IsAgent()]         # tous les rôles
        elif self.request.method == 'DELETE':
            return [IsAdmin()]         # admins seulement
        return [IsAdmin()]             # fallback sécurisé
    
    def get(self, request, pk=None):
        if pk is None:
            specialites = Specialite.objects.all()
            serializer = SpecialiteSerializer(specialites, many=True, context={'request': request})
            return Response(serializer.data)

        try:
            specialite = Specialite.objects.get(pk=pk)
        except Specialite.DoesNotExist:
            return Response({'error': 'Specialite not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = SpecialiteSerializer(specialite, context={'request': request})
        return Response(serializer.data)
    
    # def get(self, request):
    #     specialites = Specialite.objects.all()
    #     serializer = SpecialiteSerializer(specialites, many=True)
    #     return Response(serializer.data)
    
    def post(self, request):
        serializer = SpecialiteSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)
    
    def put(self, request, pk):
        try:
            specialite = Specialite.objects.get(pk=pk)
        except Specialite.DoesNotExist:
            return Response({'error': 'Specialite not found'}, status=404)

        serializer = SpecialiteSerializer(specialite, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=200)
        return Response(serializer.errors, status=400)
    
    def delete(self, request, pk):
        try:
            specialite = Specialite.objects.get(pk=pk)
        except Specialite.DoesNotExist:
            return Response({'error': 'Specialite not found'}, status=404)
        specialite.delete()
        return Response({'message': 'Specialite deleted successfully'}, status=200)
    

@extend_schema_view(
    get=extend_schema(tags=['Intérêts Spécialité'], summary="Lister les intérêts d'un prospect pour une spécialité", responses=interetSpecialiteSerializer(many=True)),
    post=extend_schema(tags=['Intérêts Spécialité'], summary="Créer un intérêt spécialité", request=interetSpecialiteSerializer, responses=interetSpecialiteSerializer),
    put=extend_schema(tags=['Intérêts Spécialité'], summary="Mettre à jour un intérêt spécialité", request=interetSpecialiteSerializer, responses=interetSpecialiteSerializer),
    delete=extend_schema(tags=['Intérêts Spécialité'], summary="Supprimer un intérêt spécialité", responses={200: None}),
)
class interetSpecialiteView(APIView):
    parser_classes = [JSONParser, MultiPartParser, FormParser]

    def get(self, request):
        interets = interetSpecialite.objects.all()
        serializer = interetSpecialiteSerializer(interets, many=True)
        return Response(serializer.data)
    
    def post(self, request):
        serializer = interetSpecialiteSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)
    
    def put(self, request, pk):
        try:
            interet = interetSpecialite.objects.get(pk=pk)
        except interetSpecialite.DoesNotExist:
            return Response({'error': 'Interet not found'}, status=404)

        serializer = interetSpecialiteSerializer(interet, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=200)
        return Response(serializer.errors, status=400)

    def delete(self, request, pk):
        try:
            interet = interetSpecialite.objects.get(pk=pk)
        except interetSpecialite.DoesNotExist:
            return Response({'error': 'Interet not found'}, status=404)
        interet.delete()
        return Response({'message': 'Interet deleted successfully'}, status=200)
    
class interetSpecialiteByProspectView(APIView):
    parser_classes = [JSONParser, MultiPartParser, FormParser]

    def get(self, request, prospect_id):
        interets = interetSpecialite.objects.filter(idProspect=prospect_id)
        serializer = interetSpecialiteSerializer(interets, many=True)
        return Response(serializer.data)
