from django.urls import path

from ISETAG_COM_API import settings
# from .views import AppliesServicesView, LoginView, UserView, ServiceView, categoryView,applyView,servicesUserView
from django.conf.urls.static import static

from user_api.views import UtilisateurView

urlpatterns = urlpatterns = [
    path('ISETAG_COM.users/',          UtilisateurView.as_view()),
    path('ISETAG_COM.users/<int:pk>/', UtilisateurView.as_view()),
] 