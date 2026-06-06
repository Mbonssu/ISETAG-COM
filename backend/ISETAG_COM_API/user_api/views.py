from django.shortcuts import render
# from authentification.permissions import IsAdmin, IsSuperviseur, IsAgent
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.db import IntegrityError
from .models import Utilisateur
from .serializers import UtilisateurSerializer
from rest_framework.parsers import JSONParser, MultiPartParser, FormParser


class UtilisateurView(APIView):
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
                user = Utilisateur.objects.get(pk=pk)
                serializer = UtilisateurSerializer(user, context={'request': request})
                return Response(serializer.data, status=status.HTTP_200_OK)
            except Utilisateur.DoesNotExist:
                return Response({'error': 'user not found'}, status=status.HTTP_404_NOT_FOUND)

        users = Utilisateur.objects.all()
        serializer = UtilisateurSerializer(users, many=True, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = UtilisateurSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            try:
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            except IntegrityError:
                return Response(
                    {'error': 'Un utilisateur avec cet email ou ce code existe déjà'},
                    status=status.HTTP_400_BAD_REQUEST
                )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk):
        try:
            user = Utilisateur.objects.get(pk=pk)
        except Utilisateur.DoesNotExist:
            return Response({'error': 'user not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = UtilisateurSerializer(user, data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        try:
            user = Utilisateur.objects.get(pk=pk)
            user.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Utilisateur.DoesNotExist:
            return Response({'error': 'user not found'}, status=status.HTTP_404_NOT_FOUND)