
import os
from pathlib import Path
from datetime import timedelta

BASE_DIR = Path(__file__).resolve().parent.parent

# En prod, definir la variable d'environnement DJANGO_SECRET_KEY.
# La valeur ci-dessous ne reste que comme filet de securite pour le dev local.
SECRET_KEY = os.environ.get(
    'DJANGO_SECRET_KEY',
    'django-insecure-x@c#(cf13$2fa!8%h7ekj$p8y&$$!z(y6_23%#rfdy6i-(h#v!'
)

DEBUG = os.environ.get('DJANGO_DEBUG', 'True') == 'True'

ALLOWED_HOSTS = os.environ.get('DJANGO_ALLOWED_HOSTS', '*').split(',')

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    #'channels',
    'campagne_api',
    'prospect_api',
    'user_api',
    'specialite_api',
    'rest_framework',
    'rest_framework_simplejwt',
    'corsheaders',
    'drf_spectacular',
    # 'authentification',   # ← ton app authentication
    ]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'corsheaders.middleware.CorsMiddleware',  # doit venir avant CommonMiddleware
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'ISETAG_COM_API.urls'

# --- CORS ---
# En dev, on autorise explicitement les origines du frontend Vite/React.
# En prod, definir DJANGO_CORS_ALLOWED_ORIGINS='https://mondomaine.com,https://autre.com'
_cors_env = os.environ.get('DJANGO_CORS_ALLOWED_ORIGINS')
if _cors_env:
    CORS_ALLOWED_ORIGINS = [origin.strip() for origin in _cors_env.split(',')]
else:
    CORS_ALLOWED_ORIGINS = [
        'http://localhost:5173',
        'http://127.0.0.1:5173',
        'http://localhost:3000',
        'http://127.0.0.1:3000',
        'https://cake-reset-smoky.ngrok-free.dev'
    ]
CORS_ALLOW_CREDENTIALS = True

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'ISETAG_COM_API.wsgi.application'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('DB_NAME', 'ISETAG-COM'),
        'USER': os.environ.get('DB_USER', 'postgres'),
        'PASSWORD': os.environ.get('DB_PASSWORD', 'Nounawo29@03'),
        'HOST': os.environ.get('DB_HOST', 'localhost'),
        'PORT': os.environ.get('DB_PORT', '5432'),
    }
}

AUTH_USER_MODEL = 'user_api.Utilisateur'  # ← si pas encore fait

REST_FRAMEWORK = {
    'DEFAULT_RENDERER_CLASSES': ['rest_framework.renderers.JSONRenderer'],
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ],
    'DEFAULT_SCHEMA_CLASS': 'drf_spectacular.openapi.AutoSchema',
    # 'DEFAULT_PERMISSION_CLASSES': [
    #     'rest_framework.permissions.IsAuthenticated',
    # ],
}

SPECTACULAR_SETTINGS = {
    'TITLE': 'ISETAG_COM_API',
    'DESCRIPTION': (
        "API de prospection ISETAG-COM : gestion des campagnes de prospection, "
        "zones et etablissements, sorties terrain, prospects, rendez-vous, "
        "suivis et relances."
    ),
    'VERSION': '1.0.0',
    'SERVE_INCLUDE_SCHEMA': False,
    # L'authentification etant volontairement debranchee pour l'instant,
    # Swagger UI n'affichera pas de cadenas "Authorize" tant que le JWT n'est pas reactive.
    'COMPONENT_SPLIT_REQUEST': True,
    'SORT_OPERATIONS': False,
}

# SIMPLE_JWT = {
    
#     # Remplace 'utilisateur_id' par le vrai nom de ta PK
#     'USER_ID_FIELD': 'idUtilisateur',   # ← le nom du champ dans le modèle
#     'USER_ID_CLAIM': 'user_id',          # ← le nom de la claim dans le token JWT
    
#     'ACCESS_TOKEN_LIFETIME': timedelta(minutes=30),   # durée de vie du token d'accès
#     'REFRESH_TOKEN_LIFETIME': timedelta(days=7),       # durée de vie du refresh token
#     'ROTATE_REFRESH_TOKENS': True,    # génère un nouveau refresh token à chaque refresh
#     'BLACKLIST_AFTER_ROTATION': True, # invalide l'ancien refresh token
#     'AUTH_HEADER_TYPES': ('Bearer',),
#     'UPDATE_LAST_LOGIN': True,
# }


AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]



LANGUAGE_CODE = 'fr-fr'

TIME_ZONE = 'Africa/Douala'

USE_I18N = True

USE_TZ = True


STATIC_URL = 'static/'

MEDIA_URL  = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')