from django.urls import path
from .views import SpecialiteView, interetSpecialiteByProspectView, interetSpecialiteView

urlpatterns = [
    path('ISETAG_COM.specialites/', SpecialiteView.as_view(), name='specialite-list-create'),
    path('ISETAG_COM.specialites/<str:pk>/', SpecialiteView.as_view(), name='specialite-detail'),
    path('ISETAG_COM.interetspecialites/', interetSpecialiteView.as_view(), name='interetspecialite-list-create'),
    path('ISETAG_COM.interetspecialites/<str:pk>/', interetSpecialiteView.as_view(), name='interetspecialite-detail'),
    path('ISETAG_COM.interetspecialites/prospect/<str:prospect_id>/', interetSpecialiteByProspectView.as_view(), name='interetspecialite-by-prospect'),
]