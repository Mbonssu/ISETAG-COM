from django.urls import path

from ISETAG_COM_API import settings
# from .views import AppliesServicesView, LoginView, UserView, ServiceView, categoryView,applyView,servicesUserView
from django.conf.urls.static import static

from prospect_api.views import ProspectView, RendezVousView, SuiviProspectView

urlpatterns = urlpatterns = [
    path('ISETAG_COM.prospects/', ProspectView.as_view(), name='prospects'),
    path('ISETAG_COM.prospects/<str:pk>/', ProspectView.as_view(), name='prospect-detail'),
    path('ISETAG_COM.rendezvous/', RendezVousView.as_view(), name='prospect-rendezvous'),
    path('ISETAG_COM.rendezvous/<str:pk>/', RendezVousView.as_view(), name='prospect-rendezvous-detail'),
    path('ISETAG_COM.suivis/', SuiviProspectView.as_view(), name='prospect-suivis'),
    path('ISETAG_COM.suivis/<str:pk>/', SuiviProspectView.as_view(), name='prospect-suivis-detail'),
] 