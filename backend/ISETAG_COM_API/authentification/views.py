from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.serializers import TokenRefreshSerializer  # si besoin
from .serializers import CustomTokenSerializer
from drf_spectacular.utils import extend_schema, extend_schema_view, OpenApiExample


@extend_schema(
    tags=['auth'],
    summary="Se connecter",
    description="Authentifie un utilisateur via email/mot de passe et retourne une paire de tokens JWT (access + refresh).",
    request=CustomTokenSerializer,
    responses={
        200: CustomTokenSerializer,
        401: OpenApiExample(
            "Identifiants invalides",
            value={"detail": "No active account found with the given credentials"},
        ),
    },
)
class LoginView(TokenObtainPairView):
    serializer_class = CustomTokenSerializer


@extend_schema(
    tags=['auth'],
    summary="Se déconnecter",
    description="Blackliste le refresh token pour invalider la session de l'utilisateur.",
    request={
        "application/json": {
            "type": "object",
            "properties": {"refresh": {"type": "string"}},
            "required": ["refresh"],
        }
    },
    responses={
        205: OpenApiExample("Succès", value={"detail": "Déconnexion réussie."}),
        400: OpenApiExample("Erreur", value={"detail": "Token invalide."}),
    },
)
class LogoutView(APIView):
    def post(self, request):
        try:
            token = RefreshToken(request.data["refresh"])
            token.blacklist()
            return Response({"detail": "Déconnexion réussie."}, status=205)
        except Exception:
            return Response({"detail": "Token invalide."}, status=400)