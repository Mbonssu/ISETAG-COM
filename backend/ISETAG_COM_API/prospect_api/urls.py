from django.urls import path

from ISETAG_COM_API import settings
# from .views import AppliesServicesView, LoginView, UserView, ServiceView, categoryView,applyView,servicesUserView
from django.conf.urls.static import static

from prospect_api.views import ProspectRelanceView, ProspectRendezVousView, ProspectSuiviView, ProspectView, RendezVousView, SuiviProspectView, RelanceView

urlpatterns = urlpatterns = [
    path('ISETAG_COM.prospects/', ProspectView.as_view(), name='prospects'),
    path('ISETAG_COM.prospects/<str:pk>/', ProspectView.as_view(), name='prospect-detail'),
    path('ISETAG_COM.rendezvous/', RendezVousView.as_view(), name='prospect-rendezvous'),
    path('ISETAG_COM.rendezvous/<str:pk>/', RendezVousView.as_view(), name='prospect-rendezvous-detail'),
    path('ISETAG_COM.suivis/', SuiviProspectView.as_view(), name='prospect-suivis'),
    path('ISETAG_COM.suivis/<str:pk>/', SuiviProspectView.as_view(), name='prospect-suivis-detail'),
    path('ISETAG_COM.relances/', RelanceView.as_view(), name='prospect-relances'),
    path('ISETAG_COM.relances/<str:pk>/', RelanceView.as_view(), name='prospect-relances-detail'),
    path('ISETAG_COM.prospects/<str:pk>/rendezvous/', ProspectRendezVousView.as_view(), name='prospect-rendezvous-list'),
    path('ISETAG_COM.prospects/<str:pk>/suivis/', ProspectSuiviView.as_view(), name='prospect-suivis-list'),
    path('ISETAG_COM.prospects/<str:pk>/relances/', ProspectRelanceView.as_view(), name='prospect-relances-list'),
] 