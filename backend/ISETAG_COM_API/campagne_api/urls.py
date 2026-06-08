from django.urls import path

from ISETAG_COM_API import settings
from .views import CampagneView, ZoneView, SortieView, SourceView, ParticipationView, ficheSortieView
from django.conf.urls.static import static

urlpatterns = urlpatterns = [
    path('campagnes/', CampagneView.as_view(), name='campagnes'),
    path('campagnes/<str:pk>/', CampagneView.as_view(), name='campagne-detail'),
    path('zones/', ZoneView.as_view(), name='zones'),
    path('zones/<str:pk>/', ZoneView.as_view(), name='zone-detail'),
    path('sorties/', SortieView.as_view(), name='sorties'),
    path('sorties/<str:pk>/', SortieView.as_view(), name='sortie-detail'),
    path('sources/', SourceView.as_view(), name='sources'),
    path('participations/', ParticipationView.as_view(), name='participations'),
    path('participations/<str:pk>/', ParticipationView.as_view(), name='participation-detail'),
    path('fiches-sortie/', ficheSortieView.as_view(), name='fiches-sortie'),
    path('fiches-sortie/<str:pk>/', ficheSortieView.as_view(), name='fiche-sortie-detail'),
] 