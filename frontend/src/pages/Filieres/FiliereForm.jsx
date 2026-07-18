// pages/Filieres/FiliereForm.jsx

import React, { useState, useEffect } from "react";
import { useNavigate, useParams } from "react-router-dom";
import {
  Save,
  ArrowLeft,
  AlertCircle,
  GraduationCap,
  BookOpen,
  Hash,
} from "lucide-react";
import { ToastContainer } from "../../components/common/Toast";
import { useFormValidation, validators } from "../../hooks/useFormValidation";
import { specialiteService } from "../../services/filiereService";
import "../Prospects/Prospects.css";

const FiliereForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;
  const [toasts, setToasts] = useState([]);
  const [loading, setLoading] = useState(false);
  const [loadingData, setLoadingData] = useState(false);

  const addToast = (message, type = "success") => {
    const toastId = Date.now();
    setToasts((prev) => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };

  const removeToast = (id) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  };

  // ============================================================
  // 1. RÈGLES DE VALIDATION
  // ============================================================

  const validationRules = {
    libeleSpecialite: [
      validators.required("Le libellé de la spécialité est requis")
    ],
    acronyme: [
      validators.required("L'acronyme est requis"),
      validators.maxLength(10, "L'acronyme doit faire moins de 10 caractères")
    ],
  };

  // ============================================================
  // 2. VALEURS INITIALES
  // ============================================================

  const {
    values,
    errors,
    touched,
    handleChange,
    handleBlur,
    validateForm,
    setFieldValue,
  } = useFormValidation(
    {
      idSpecialite: null,
      libeleSpecialite: "",
      acronyme: "",
      description: "",
    },
    validationRules
  );

  // ============================================================
  // 3. CHARGEMENT DES DONNÉES (MODE ÉDITION)
  // ============================================================

  useEffect(() => {
    if (isEdit && id) {
      loadSpecialiteData(id);
    }
  }, [isEdit, id]);

  const loadSpecialiteData = async (specialiteId) => {
    setLoadingData(true);
    try {
      const data = await specialiteService.getById(specialiteId);
      ("📥 Données de la spécialité chargées:", data);
      
      setFieldValue("idSpecialite", data.idSpecialite);
      setFieldValue("libeleSpecialite", data.libeleSpecialite || "");
      setFieldValue("acronyme", data.acronyme || "");
      setFieldValue("description", data.description || "");
      
    } catch (error) {
      console.error(" Erreur chargement spécialité:", error);
      addToast(
        `Erreur lors du chargement de la spécialité: ${error.message}`,
        "error"
      );
      setTimeout(() => navigate("/filieres"), 2000);
    } finally {
      setLoadingData(false);
    }
  };

  // ============================================================
  // 4. SOUMISSION DU FORMULAIRE
  // ============================================================

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!validateForm()) {
      addToast("Veuillez corriger les erreurs dans le formulaire", "error");
      return;
    }

    setLoading(true);
    
    try {
      const specialiteData = {
        libeleSpecialite: values.libeleSpecialite,
        acronyme: values.acronyme.toUpperCase(), // Mettre en majuscules
        description: values.description || "",
      };

      ("📤 Données à envoyer:", specialiteData);

      if (isEdit) {
        await specialiteService.update(id, specialiteData);
        addToast("Spécialité modifiée avec succès", "success");
      } else {
        await specialiteService.create(specialiteData);
        addToast("Spécialité créée avec succès", "success");
      }

      setTimeout(() => navigate("/filieres"), 1500);
      
    } catch (error) {
      console.error(" Erreur lors de l'enregistrement:", error);
      
      if (error.response?.data) {
        const backendErrors = error.response.data;
        const errorMessages = [];
        
        Object.keys(backendErrors).forEach(key => {
          const message = Array.isArray(backendErrors[key]) 
            ? backendErrors[key].join(', ') 
            : backendErrors[key];
          errorMessages.push(`${key}: ${message}`);
        });
        
        addToast(
          `Erreur: ${errorMessages.join(' | ')}`,
          "error"
        );
      } else {
        addToast(
          `Erreur: ${error.message || "Erreur lors de l'enregistrement"}`,
          "error"
        );
      }
    } finally {
      setLoading(false);
    }
  };

  // ============================================================
  // 5. AFFICHAGE DU CHARGEMENT
  // ============================================================

  if (loadingData) {
    return (
      <div className="page-container">
        <div className="text-center py-5">
          <div className="spinner-border text-primary" role="status">
            <span className="visually-hidden">Chargement...</span>
          </div>
          <p className="mt-3">Chargement de la spécialité...</p>
        </div>
      </div>
    );
  }

  // ============================================================
  // 6. RENDER - PAGE PRINCIPALE
  // ============================================================

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">
            {isEdit ? "Modifier la spécialité" : "Nouvelle spécialité"}
          </h1>
          <p className="page-description">
            {isEdit
              ? "Modifiez les informations de la spécialité."
              : "Ajoutez une nouvelle spécialité de formation."}
          </p>
        </div>
        <button 
          className="btn-outline" 
          onClick={() => navigate("/filieres")}
          disabled={loading}
        >
          <ArrowLeft size={18} /> Retour
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          {/* Champ caché pour l'ID */}
          <input type="hidden" name="idSpecialite" value={values.idSpecialite || ''} />

          {/* Libellé de la spécialité */}
          <div className="form-group full-width">
            <label>
              Libellé de la spécialité <span className="required">*</span>
            </label>
            <div className="input-icon">
              <BookOpen size={18} />
              <input
                type="text"
                name="libeleSpecialite"
                value={values.libeleSpecialite}
                onChange={handleChange}
                onBlur={handleBlur}
                disabled={loading}
                className={errors.libeleSpecialite && touched.libeleSpecialite ? "error" : ""}
                placeholder="Ex: Informatique, Génie Logiciel, Marketing..."
              />
            </div>
            {errors.libeleSpecialite && touched.libeleSpecialite && (
              <span className="error-message">
                <AlertCircle size={12} /> {errors.libeleSpecialite}
              </span>
            )}
          </div>

          {/* Acronyme */}
          <div className="form-group">
            <label>
              Acronyme <span className="required">*</span>
            </label>
            <div className="input-icon">
              <Hash size={18} />
              <input
                type="text"
                name="acronyme"
                value={values.acronyme}
                onChange={handleChange}
                onBlur={handleBlur}
                disabled={loading}
                maxLength="10"
                className={errors.acronyme && touched.acronyme ? "error" : ""}
                placeholder="Ex: INF, GL, MKT..."
                style={{ textTransform: "uppercase" }}
              />
            </div>
            {errors.acronyme && touched.acronyme && (
              <span className="error-message">
                <AlertCircle size={12} /> {errors.acronyme}
              </span>
            )}
            <small className="text-muted">
              L'acronyme sera automatiquement mis en majuscules
            </small>
          </div>

          {/* Description */}
          <div className="form-group full-width">
            <label>Description</label>
            <div className="input-icon">
              <GraduationCap size={18} />
              <textarea
                name="description"
                rows="4"
                value={values.description}
                onChange={handleChange}
                disabled={loading}
                placeholder="Description détaillée de la spécialité..."
                style = {{width: '120%'}}
              />
            </div>
            <small className="text-muted">
              Décrivez les objectifs, le contenu et les débouchés de cette spécialité
            </small>
          </div>

          {/* Affichage de l'ID en mode édition */}
          {isEdit && (
            <div className="form-group" style={{ opacity: 0.7 }}>
              <label>ID de la spécialité</label>
              <div className="input-icon" style={{ background: '#f8f9fa' }}>
                <Hash size={18} />
                <input
                  type="text"
                  value={id}
                  disabled
                  style={{ 
                    background: '#f8f9fa', 
                    cursor: 'not-allowed',
                    fontWeight: 'bold',
                  }}
                />
              </div>
              <small className="text-muted">L'ID est généré automatiquement et ne peut pas être modifié</small>
            </div>
          )}
        </div>

        {/* Boutons d'action */}
        <div className="form-actions">
          <button
            type="button"
            className="btn-outline"
            onClick={() => navigate("/filieres")}
            disabled={loading}
          >
            Annuler
          </button>
          <button 
            type="submit" 
            className="btn-primary"
            disabled={loading}
          >
            {loading ? (
              <>
                <span className="spinner-border spinner-border-sm me-2" />
                {isEdit ? "Mise à jour..." : "Création..."}
              </>
            ) : (
              <>
                <Save size={18} />
                {isEdit ? "Mettre à jour" : "Créer"}
              </>
            )}
          </button>
        </div>
      </form>
    </div>
  );
};

export default FiliereForm;
