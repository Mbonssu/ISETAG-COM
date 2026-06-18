from django.urls import path

from ISETAG_COM_API import settings
from .views import CampagneView, ZoneView, SortieView, SourceView, ParticipationView, etablissementView, ficheSortieView
from django.conf.urls.static import static

urlpatterns = urlpatterns = [
    path('ISETAG_COM.campagnes/', CampagneView.as_view(), name='campagnes'),
    path('ISETAG_COM.campagnes/<str:pk>/', CampagneView.as_view(), name='campagne-detail'),
    path('ISETAG_COM.zones/', ZoneView.as_view(), name='zones'),
    path('ISETAG_COM.zones/<str:pk>/', ZoneView.as_view(), name='zone-detail'),
    path('ISETAG_COM.sorties/', SortieView.as_view(), name='sorties'),
    path('ISETAG_COM.sorties/<str:pk>/', SortieView.as_view(), name='sortie-detail'),
    path('ISETAG_COM.sources/', SourceView.as_view(), name='sources'),
    path('ISETAG_COM.sources/<str:pk>/', SourceView.as_view(), name='source-detail'),
    path('ISETAG_COM.participations/', ParticipationView.as_view(), name='participations'),
    path('ISETAG_COM.participations/<str:pk>/', ParticipationView.as_view(), name='participation-detail'),
    path('ISETAG_COM.fiches-sortie/', ficheSortieView.as_view(), name='fiches-sortie'),
    path('ISETAG_COM.fiches-sortie/<str:pk>/', ficheSortieView.as_view(), name='fiche-sortie-detail'),
    path('ISETAG_COM.etablissements/', etablissementView.as_view(), name='etablissements'),
    path('ISETAG_COM.etablissements/<str:pk>/', etablissementView.as_view(), name='etablissement-detail'),
] 