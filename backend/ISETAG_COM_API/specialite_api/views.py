from django.shortcuts import render

from .models import Specialite, interetSpecialite
from rest_framework.views import APIView
from rest_framework.response import Response
from .serializers import SpecialiteSerializer, interetSpecialiteSerializer
from rest_framework.parsers import JSONParser, MultiPartParser, FormParser
# from .ws_utils import notify_service_created, notify_service_updated, notify_service_deleted
# from authentification.permissions import IsAdmin, IsSuperviseur,IsAgent

class SpecialiteView(APIView):
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
    
    def get(self, request):
        specialites = Specialite.objects.all()
        serializer = SpecialiteSerializer(specialites, many=True)
        return Response(serializer.data)
    
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
