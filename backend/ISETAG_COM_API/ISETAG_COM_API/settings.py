
import os
from pathlib import Path
from datetime import timedelta

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = 'django-insecure-x@c#(cf13$2fa!8%h7ekj$p8y&$$!z(y6_23%#rfdy6i-(h#v!'

DEBUG = True

ALLOWED_HOSTS = ['*']

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'channels',
    'campagne_api',
    'prospect_api',
    'user_api',
    'rest_framework',
    'rest_framework_simplejwt',
    'corsheaders',
    'authentification',   # ← ton app authentication
    ]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'corsheaders.middleware.CorsMiddleware',
]

ROOT_URLCONF = 'ISETAG_COM_API.urls'

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
        'NAME': 'ISETAG-COM',
        'USER':'postgres',
        'PASSWORD':'Nounawo29@03',
        'HOST':'localhost',
        'PORT':'5432'
    }
}

AUTH_USER_MODEL = 'user_api.Utilisateur'  # ← si pas encore fait

REST_FRAMEWORK = {
    'DEFAULT_RENDERER_CLASSES': ['rest_framework.renderers.JSONRenderer'],
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ],
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.IsAuthenticated',
    ],
}

SIMPLE_JWT = {
    
    # Remplace 'utilisateur_id' par le vrai nom de ta PK
    'USER_ID_FIELD': 'idUtilisateur',   # ← le nom du champ dans le modèle
    'USER_ID_CLAIM': 'user_id',          # ← le nom de la claim dans le token JWT
    
    
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=30),   # durée de vie du token d'accès
    'REFRESH_TOKEN_LIFETIME': timedelta(days=7),       # durée de vie du refresh token
    'ROTATE_REFRESH_TOKENS': True,    # génère un nouveau refresh token à chaque refresh
    'BLACKLIST_AFTER_ROTATION': True, # invalide l'ancien refresh token
    'AUTH_HEADER_TYPES': ('Bearer',),
    'UPDATE_LAST_LOGIN': True,
}


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



LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True


STATIC_URL = 'static/'

MEDIA_URL  = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')