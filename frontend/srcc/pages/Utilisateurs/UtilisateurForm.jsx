import React, { useState, useEffect } from "react";
import { useNavigate, useParams } from "react-router-dom";
import {
  Save,
  ArrowLeft,
  AlertCircle,
  User,
  Mail,
  Phone,
  Key,
  Shield,
  Calendar,
  Eye,
  EyeOff,
} from "lucide-react";
import { ToastContainer } from "../../components/common/Toast";
import { useTranslation } from "../../hooks/useTranslation";
import { userService } from "../../services/userService";
import "../Prospects/Prospects.css";
import "./Utilisateurs.css";

const UtilisateurForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [toasts, setToasts] = useState([]);
  const [errors, setErrors] = useState({});

  const addToast = (message, type = "success") => {
    const toastId = Date.now();
    setToasts((prev) => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };

  const removeToast = (id) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  };

  const [formData, setFormData] = useState({
    username: "",
    nom: "",
    prenom: "",
    email: "",
    telephone: "",
    role: "Agent",
    statut: "actif",
    actif: true,
    dateEmbauche: "",
    password: "",
    confirmPassword: "",
  });

  const roles = [
    { value: "Administrateur", label: "Administrateur - Acces total" },
    { value: "Manager", label: "Manager - Gestion des equipes" },
    { value: "Agent", label: "Agent - Gestion des prospects" },
    { value: "Viewer", label: "Viewer - Consultation uniquement" },
  ];

  const statuts = [
    { value: "actif", label: "Actif" },
    { value: "inactif", label: "Inactif" },
    { value: "suspendu", label: "Suspendu" },
  ];

  const validateForm = () => {
    const newErrors = {};

    console.log("[VALIDATION] Verification du formulaire:", formData);

    if (!formData.username.trim()) {
      newErrors.username = "Le nom d'utilisateur est requis";
    } else if (!/^[\w.@+-]+$/.test(formData.username)) {
      newErrors.username = "Lettres, chiffres et @/./+/-/_ uniquement";
    }
    if (!formData.nom.trim()) newErrors.nom = "Le nom est requis";
    if (!formData.prenom.trim()) newErrors.prenom = "Le prenom est requis";
    if (!formData.email.trim()) newErrors.email = "L'email est requis";
    else if (!/\S+@\S+\.\S+/.test(formData.email))
      newErrors.email = "Email invalide";
    if (!formData.telephone.trim())
      newErrors.telephone = "Le telephone est requis";
    else if (!/^[0-9]{9,10}$/.test(formData.telephone.replace(/\s/g, ""))) {
      newErrors.telephone = "Telephone invalide (9-10 chiffres)";
    }
    if (!formData.role) newErrors.role = "Le role est requis";

    if (!isEdit) {
      if (!formData.password) newErrors.password = "Le mot de passe est requis";
      else if (formData.password.length < 8)
        newErrors.password = "Minimum 8 caracteres";
      if (formData.password !== formData.confirmPassword) {
        newErrors.confirmPassword = "Les mots de passe ne correspondent pas";
      }
    }

    console.log("[VALIDATION] Erreurs de validation:", newErrors);
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    console.log(
      `[MODIFICATION] Champ modifie: ${name} = ${type === "checkbox" ? checked : value}`,
    );

    setFormData((prev) => {
      const newData = {
        ...prev,
        [name]: type === "checkbox" ? checked : value,
      };
      console.log("[STATE] Nouveau state du formulaire:", newData);
      return newData;
    });

    if (errors[name]) {
      setErrors((prev) => ({ ...prev, [name]: "" }));
    }
  };

  useEffect(() => {
    if (isEdit) {
      const fetchUser = async () => {
        try {
          console.log("[CHARGEMENT] Utilisateur ID:", id);
          const response = await userService.getById(id);
          console.log("[CHARGEMENT] Reponse:", response);

          const userData = response.data || response;
          console.log("[CHARGEMENT] Donnees utilisateur recues:", userData);

          const passwordValue = userData.password || userData.password_display || '' ;

          setFormData({
            username: userData.username || "",
            nom: userData.nom || "",
            prenom: userData.prenom || "",
            email: userData.email || "",
            telephone: userData.telephone || "",
            role: userData.role || "Agent",
            statut: userData.statut || "actif",
            actif: userData.actif !== undefined ? userData.actif : true,
            dateEmbauche: userData.dateEmbauche || "",
            password: passwordValue,
            confirmPassword:passwordValue,
          });
        } catch (error) {
          console.error("[ERREUR] Erreur de chargement:", error);
          addToast("Erreur lors du chargement des donnees", "error");
          navigate("/utilisateurs");
        }
      };
      fetchUser();
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id, isEdit, navigate]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log("[SOUMISSION] Formulaire soumis");
    console.log("[DONNEES] Formulaire:", formData);

    if (!validateForm()) {
      console.log("[ERREUR] Formulaire invalide");
      addToast("Veuillez corriger les erreurs dans le formulaire", "error");
      return;
    }

    setLoading(true);
    try {
      // Preparer les donnees pour l'API
      const userData = {
        username: formData.username,
        nom: formData.nom,
        prenom: formData.prenom,
        email: formData.email,
        telephone: formData.telephone,
        role: formData.role,
        statut: formData.statut,
        actif: formData.actif,
        dateEmbauche: formData.dateEmbauche || null,
      };

      if (!isEdit) {
        // Le username est definitif, fixe uniquement a la creation
        // (AbstractUser.username, unique, requis par Django).
        userData.username = formData.username;
        userData.password = formData.password;
        /**
         * Le serializer backend (UtilisateurSerializer.create) genere lui-meme
         * idUtilisateur via uuid et ecrasera toute valeur qu'on envoie ici.
         * MAIS comme idUtilisateur est la primary key du modele et que le
         * serializer utilise `fields = '__all__'` sans `extra_kwargs`,
         * DRF l'exige quand meme au moment de la validation d'entree,
         * avant meme d'atteindre create(). On envoie donc une valeur
         * temporaire, purement pour satisfaire cette validation ;
         * le backend la remplace systematiquement par la vraie valeur.
         *
         * Ceci est un contournement front. La vraie correction est
         * cote backend : ajouter dans UtilisateurSerializer.Meta
         *   extra_kwargs = { 'idUtilisateur': { 'required': False } }
         */
        userData.idUtilisateur = `TEMP-${Date.now()}`;
      } else {
        userData.idUtilisateur = id;
        console.log(`ID utilisateur inclus pour la mise a jour : ${id}`);
      }

      // Ajouter le mot de passe uniquement pour la creation ou s'il est rempli en edition
      if (!isEdit) {
        userData.password = formData.password;
        console.log("[MOT DE PASSE] Ajoute pour la creation");
      } else if (formData.password) {
        userData.password = formData.password;
        console.log("[MOT DE PASSE] Mis a jour");
      }

      console.log(
        "[API] Donnees envoyees:",
        JSON.stringify(userData, null, 2),
      );

      let response;
      if (isEdit) {
        console.log(`[MISE A JOUR] Utilisateur ID: ${id}`);
        response = await userService.update(id, userData);
        console.log("[SUCCES] Reponse de mise a jour:", response);
        addToast("Utilisateur modifie avec succes", "success");
      } else {
        console.log("[CREATION] Nouvel utilisateur");
        response = await userService.create(userData);
        console.log("[SUCCES] Reponse de creation:", response);
        addToast("Utilisateur cree avec succes", "success");
      }

      console.log("[REPONSE] Reponse complete du serveur:", response);

      setTimeout(() => {
        navigate("/utilisateurs");
      }, 1500);
    } catch (error) {
      console.error("[ERREUR] Erreur complete:", error);
      console.error("[ERREUR] Message:", error.message);
      console.error("[ERREUR] Stack trace:", error.stack);

      let errorMessage = "Erreur lors de l'enregistrement";

      if (error.response) {
        console.error("[ERREUR] Reponse:", error.response);
        try {
          const errorData = await error.response.json();
          console.error("[ERREUR] Donnees:", errorData);
          errorMessage =
            errorData.message ||
            errorData.detail ||
            errorData.non_field_errors?.[0] ||
            errorMessage;
        } catch (e) {
          console.error("[ERREUR] Parsing reponse:", e);
        }
      }

      addToast(errorMessage, "error");

      // Afficher les erreurs de validation du backend
      if (error.response?.data) {
        const backendErrors = error.response.data;
        if (typeof backendErrors === "object") {
          const fieldErrors = {};
          Object.keys(backendErrors).forEach((key) => {
            if (Array.isArray(backendErrors[key])) {
              fieldErrors[key] = backendErrors[key][0];
            } else if (typeof backendErrors[key] === "string") {
              fieldErrors[key] = backendErrors[key];
            }
          });
          setErrors((prev) => ({ ...prev, ...fieldErrors }));
        }
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">
            {isEdit ? "Modifier l'utilisateur" : "Nouvel utilisateur"}
          </h1>
          <p className="page-description">
            {isEdit
              ? "Modifiez les informations de l'utilisateur."
              : "Ajoutez un nouvel utilisateur a la plateforme."}
          </p>
        </div>
        <button
          className="btn-outline"
          onClick={() => navigate("/utilisateurs")}
        >
          <ArrowLeft size={18} /> Retour
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          {/* Nom d'utilisateur (login) - fixe uniquement a la creation */}
          <div className="form-group">
            <label>
              Nom d'utilisateur {!isEdit && <span className="required">*</span>}
            </label>
            <div className="input-icon">
              <User size={18} />
              <input
                type="text"
                name="username"
                value={formData.username}
                onChange={handleChange}
                placeholder="ex: jdupont"
                className={errors.username ? "error" : ""}
              />
            </div>
            {errors.username && (
              <span className="error-message">
                <AlertCircle size={12} /> {errors.username}
              </span>
            )}
          </div>

          {/* Nom */}
          <div className="form-group">
            <label>
              Nom <span className="required">*</span>
            </label>
            <div className="input-icon">
              <User size={18} />
              <input
                type="text"
                name="nom"
                value={formData.nom}
                onChange={handleChange}
                placeholder="Nom de l'utilisateur"
                className={errors.nom ? "error" : ""}
              />
            </div>
            {errors.nom && (
              <span className="error-message">
                <AlertCircle size={12} /> {errors.nom}
              </span>
            )}
          </div>

          {/* Prenom */}
          <div className="form-group">
            <label>
              Prenom <span className="required">*</span>
            </label>
            <div className="input-icon">
              <User size={18} />
              <input
                type="text"
                name="prenom"
                value={formData.prenom}
                onChange={handleChange}
                placeholder="Prenom de l'utilisateur"
                className={errors.prenom ? "error" : ""}
              />
            </div>
            {errors.prenom && (
              <span className="error-message">
                <AlertCircle size={12} /> {errors.prenom}
              </span>
            )}
          </div>

          {/* Email */}
          <div className="form-group">
            <label>
              Email <span className="required">*</span>
            </label>
            <div className="input-icon">
              <Mail size={18} />
              <input
                type="email"
                name="email"
                value={formData.email}
                onChange={handleChange}
                placeholder="utilisateur@isetag.com"
                className={errors.email ? "error" : ""}
              />
            </div>
            {errors.email && (
              <span className="error-message">
                <AlertCircle size={12} /> {errors.email}
              </span>
            )}
          </div>

          {/* Telephone */}
          <div className="form-group">
            <label>
              Telephone <span className="required">*</span>
            </label>
            <div className="input-icon">
              <Phone size={18} />
              <input
                type="tel"
                name="telephone"
                value={formData.telephone}
                onChange={handleChange}
                placeholder="6XXXXXXXX"
                className={errors.telephone ? "error" : ""}
              />
            </div>
            {errors.telephone && (
              <span className="error-message">
                <AlertCircle size={12} /> {errors.telephone}
              </span>
            )}
          </div>

          {/* Role */}
          <div className="form-group">
            <label>
              Role <span className="required">*</span>
            </label>
            <div className="input-icon">
              <Shield size={18} />
              <select
                name="role"
                value={formData.role}
                onChange={handleChange}
                className={errors.role ? "error" : ""}
              >
                {roles.map((r) => (
                  <option key={r.value} value={r.value}>
                    {r.label}
                  </option>
                ))}
              </select>
            </div>
            {errors.role && (
              <span className="error-message">
                <AlertCircle size={12} /> {errors.role}
              </span>
            )}
          </div>

          {/* Statut */}
          <div className="form-group">
            <label>
              Statut <span className="required">*</span>
            </label>
            <div className="input-icon">
              <Shield size={18} />
              <select
                name="statut"
                value={formData.statut}
                onChange={handleChange}
                className={errors.statut ? "error" : ""}
              >
                {statuts.map((s) => (
                  <option key={s.value} value={s.value}>
                    {s.label}
                  </option>
                ))}
              </select>
            </div>
            {errors.statut && (
              <span className="error-message">
                <AlertCircle size={12} /> {errors.statut}
              </span>
            )}
          </div>

          {/* Date d'embauche */}
          <div className="form-group">
            <label>Date d'embauche</label>
            <div className="input-icon">
              <Calendar size={18} />
              <input
                type="date"
                name="dateEmbauche"
                value={formData.dateEmbauche}
                onChange={handleChange}
              />
            </div>
          </div>

          {/* Utilisateur actif */}
          <div
            className="form-group"
            style={{
              flexDirection: "row",
              alignItems: "center",
              gap: "12px",
              paddingTop: "8px",
            }}
          >
            <label
              style={{
                marginBottom: 0,
                display: "flex",
                alignItems: "center",
                cursor: "pointer",
              }}
            >
              <input
                type="checkbox"
                name="actif"
                checked={formData.actif}
                onChange={handleChange}
                style={{
                  width: "20px",
                  height: "20px",
                  marginRight: "10px",
                  cursor: "pointer",
                }}
              />
              <span
                style={{
                  fontSize: "14px",
                  fontWeight: "500",
                  color: "#374151",
                }}
              >
                Utilisateur actif
              </span>
            </label>
          </div>

          {/* Mot de passe*/}
          <div className="form-group">
            <label>
              Mot de passe {!isEdit && <span className="required">*</span>}
            </label>
            <div className="input-icon" style={{ position: "relative" }}>
              <Key
                size={18}
                style={{
                  position: "absolute",
                  left: "12px",
                  top: "50%",
                  transform: "translateY(-50%)",
                  color: "#9ca3af",
                  zIndex: 1,
                }}
              />
              <input
                type={showPassword ? "text" : "password"}
                name="password"
                value={formData.password}
                onChange={handleChange}
                placeholder={
                  isEdit
                    ? "Laisser vide pour ne pas changer"
                    : "Minimum 8 caracteres"
                }
                className={errors.password ? "error" : ""}
                style={{ paddingLeft: "40px", paddingRight: "40px" }}
              />
              <button
                type="button"
                className="password-toggle"
                onClick={() => setShowPassword(!showPassword)}
                style={{
                  position: "absolute",
                  right: "12px",
                  top: "50%",
                  transform: "translateY(-50%)",
                  background: "none",
                  border: "none",
                  cursor: "pointer",
                  color: "#9ca3af",
                  padding: "4px",
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  zIndex: 1,
                }}
              >
                {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
              </button>
            </div>
            {errors.password && (
              <span className="error-message">
                <AlertCircle size={12} /> {errors.password}
              </span>
            )}
          </div>

          {/* Confirmation mot de passe - TOUJOURS visible */}
          <div className="form-group">
            <label>
              Confirmer le mot de passe{" "}
              {!isEdit && <span className="required">*</span>}
            </label>
            <div className="input-icon" style={{ position: "relative" }}>
              <Key
                size={18}
                style={{
                  position: "absolute",
                  left: "12px",
                  top: "50%",
                  transform: "translateY(-50%)",
                  color: "#9ca3af",
                  zIndex: 1,
                }}
              />
              <input
                type={showPassword ? "text" : "password"}
                name="confirmPassword"
                value={formData.confirmPassword}
                onChange={handleChange}
                placeholder={
                  isEdit
                    ? "Laisser vide pour ne pas changer"
                    : "Confirmer le mot de passe"
                }
                className={errors.confirmPassword ? "error" : ""}
                style={{ paddingLeft: "40px" }}
              />
            </div>
            {errors.confirmPassword && (
              <span className="error-message">
                <AlertCircle size={12} /> {errors.confirmPassword}
              </span>
            )}
          </div>
        </div>

        <div className="form-actions">
          <button
            type="button"
            className="btn-outline"
            onClick={() => navigate("/utilisateurs")}
          >
            Annuler
          </button>
          <button type="submit" className="btn-primary" disabled={loading}>
            <Save size={18} />
            {loading ? "Enregistrement..." : isEdit ? "Mettre a jour" : "Creer"}
          </button>
        </div>
      </form>
    </div>
  );
};

export default UtilisateurForm;