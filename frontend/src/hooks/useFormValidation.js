// import { useState } from 'react';

// export const useFormValidation = (initialValues, rules = {}) => {
//   const [values, setValues] = useState(initialValues);
//   const [errors, setErrors] = useState({});
//   const [touched, setTouched] = useState({});

//   // ============================================================
//   // 1. VALIDER UN CHAMP UNIQUE - AVEC VÉRIFICATION DE SÉCURITÉ
//   // ============================================================

//   const validateField = (name, value) => {
//     // ✅ Vérifier si le champ existe dans les règles
//     if (!rules || !rules[name]) {
//       return ''; // Pas de règles = pas d'erreur
//     }

//     const fieldRules = rules[name];
//     if (!fieldRules || fieldRules.length === 0) {
//       return '';
//     }

//     for (const rule of fieldRules) {
//       const error = rule(value, values);
//       if (error) return error;
//     }
//     return '';
//   };

//   // ============================================================
//   // 2. VALIDER TOUS LES CHAMPS DU FORMULAIRE
//   // ============================================================

//   const validateForm = () => {
//     const newErrors = {};
//     let isValid = true;

//     // Ne valider que les champs qui ont des règles
//     Object.keys(rules).forEach((name) => {
//       const value = values[name];
//       const error = validateField(name, value);
//       if (error) {
//         newErrors[name] = error;
//         isValid = false;
//       }
//     });

//     setErrors(newErrors);
//     return isValid;
//   };

//   // ============================================================
//   // 3. GÉRER LE CHANGEMENT D'UN CHAMP
//   // ============================================================

//   const handleChange = (e) => {
//     const { name, value, type, checked } = e.target;
//     const newValue = type === 'checkbox' ? checked : value;
    
//     setValues(prev => ({ ...prev, [name]: newValue }));
    
//     // Ne valider que si le champ a été touché et a des règles
//     if (touched[name] && rules && rules[name]) {
//       const error = validateField(name, newValue);
//       setErrors(prev => ({ ...prev, [name]: error }));
//     }
//   };

//   // ============================================================
//   // 4. GÉRER LE BLUR (PERDRE LE FOCUS)
//   // ============================================================

//   const handleBlur = (e) => {
//     const { name } = e.target;
//     setTouched(prev => ({ ...prev, [name]: true }));
    
//     // Ne valider que si le champ a des règles
//     if (rules && rules[name]) {
//       const error = validateField(name, values[name]);
//       setErrors(prev => ({ ...prev, [name]: error }));
//     }
//   };

//   // ============================================================
//   // 5. DÉFINIR LA VALEUR D'UN CHAMP
//   // ============================================================

//   const setFieldValue = (name, value) => {
//     setValues(prev => ({ ...prev, [name]: value }));
    
//     // Ne valider que si le champ a été touché et a des règles
//     if (touched[name] && rules && rules[name]) {
//       const error = validateField(name, value);
//       setErrors(prev => ({ ...prev, [name]: error }));
//     }
//   };

//   // ============================================================
//   // 6. DÉFINIR PLUSIEURS VALEURS À LA FOIS
//   // ============================================================

//   const setValuesMultiple = (newValues) => {
//     setValues(prev => ({ ...prev, ...newValues }));
//   };

//   // ============================================================
//   // 7. RÉINITIALISER LE FORMULAIRE
//   // ============================================================

//   const resetForm = () => {
//     setValues(initialValues);
//     setErrors({});
//     setTouched({});
//   };

//   // ============================================================
//   // 8. EFFACER LES ERREURS D'UN CHAMP
//   // ============================================================

//   const clearError = (name) => {
//     setErrors(prev => {
//       const newErrors = { ...prev };
//       delete newErrors[name];
//       return newErrors;
//     });
//   };

//   return {
//     values,
//     errors,
//     touched,
//     handleChange,
//     handleBlur,
//     validateForm,
//     setFieldValue,
//     setValues: setValuesMultiple,
//     resetForm,
//     clearError,
//     validateField,
//   };
// };

// // ============================================================
// // RÈGLES DE VALIDATION PRÉDÉFINIES
// // ============================================================

// export const validators = {
//   required: (message = 'Ce champ est requis') => (value) => {
//     if (!value || (typeof value === 'string' && !value.trim())) return message;
//     return '';
//   },
  
//   email: (message = 'Email invalide') => (value) => {
//     // Si la valeur est vide, on ne valide pas (utiliser required si besoin)
//     if (!value) return '';
//     if (!/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i.test(value)) return message;
//     return '';
//   },
  
//   // phone: (message = 'Téléphone invalide (9-10 chiffres)') => (value) => {
//   //   if (!value) return '';
//   //   if (!/^[0-9]{9,10}$/.test(value.replace(/\s/g, ''))) return message;
//   //   return '';

//   //},

//   phone : (message = 'Numéro de téléphone invalide (9 chiffres, commence par 6)') => (value) => {
//     if (!value) return '';
//     // Supprimer les espaces et vérifier le format
//     const cleanedValue = value.replace(/\s/g, '');
//     if (!/^6\d{8}$/.test(cleanedValue)) return message;
//     return '';
//   },
  
//   minLength: (min, message) => (value) => {
//     if (!value) return '';
//     if (value.length < min) return message || `Minimum ${min} caractères`;
//     return '';
//   },
  
//   maxLength: (max, message) => (value) => {
//     if (!value) return '';
//     if (value.length > max) return message || `Maximum ${max} caractères`;
//     return '';
//   },
  
//   match: (field, fieldName, message) => (value, allValues) => {
//     if (!value) return '';
//     // Vérifier que allValues existe et que le champ existe
//     if (!allValues || !allValues[field]) {
//       return '';
//     }
//     if (value !== allValues[field]) {
//       return message || `${fieldName} ne correspond pas`;
//     }
//     return '';
//   },
  
//   number: (message = 'Doit être un nombre') => (value) => {
//     if (!value) return '';
//     if (isNaN(Number(value))) return message;
//     return '';
//   },
  
//   positive: (message = 'Doit être positif') => (value) => {
//     if (!value) return '';
//     if (Number(value) <= 0) return message;
//     return '';
//   },

//   url: (message = 'URL invalide') => (value) => {
//     if (!value) return '';
//     try {
//       new URL(value);
//       return '';
//     } catch {
//       return message;
//     }
//   },

//   min: (min, message) => (value) => {
//     if (!value) return '';
//     if (Number(value) < min) return message || `Minimum ${min}`;
//     return '';
//   },

//   max: (max, message) => (value) => {
//     if (!value) return '';
//     if (Number(value) > max) return message || `Maximum ${max}`;
//     return '';
//   },
// };

import { useState, useCallback } from 'react';

// ⚠️ CORRIGÉ : toutes les fonctions retournées par ce hook sont maintenant
// mémoïsées avec useCallback. Avant, elles étaient redéfinies à CHAQUE
// re-render (nouvelles références à chaque fois), ce qui cassait n'importe
// quel useEffect/useCallback ailleurs qui les mettait en dépendance
// (ex: ProspectForm.jsx -> loadProspect dépend de setValues) : la moindre
// mise à jour d'état ailleurs dans le formulaire (ex: supprimer un intérêt,
// changer un niveau) provoquait un re-render -> nouvelle référence de
// setValues -> nouveau loadProspect -> re-déclenchement du useEffect ->
// nouvel appel API -> nouveau setValues -> boucle infinie de GET.
export const useFormValidation = (initialValues, rules = {}) => {
  const [values, setValues] = useState(initialValues);
  const [errors, setErrors] = useState({});
  const [touched, setTouched] = useState({});

  // ============================================================
  // 1. VALIDER UN CHAMP UNIQUE - AVEC VÉRIFICATION DE SÉCURITÉ
  // ============================================================
  const validateField = useCallback((name, value) => {
    if (!rules || !rules[name]) {
      return '';
    }
    const fieldRules = rules[name];
    if (!fieldRules || fieldRules.length === 0) {
      return '';
    }
    for (const rule of fieldRules) {
      const error = rule(value, values);
      if (error) return error;
    }
    return '';
  }, [rules, values]);

  // ============================================================
  // 2. VALIDER TOUS LES CHAMPS DU FORMULAIRE
  // ============================================================
  const validateForm = useCallback(() => {
    const newErrors = {};
    let isValid = true;

    Object.keys(rules).forEach((name) => {
      const value = values[name];
      const error = validateField(name, value);
      if (error) {
        newErrors[name] = error;
        isValid = false;
      }
    });

    setErrors(newErrors);
    return isValid;
  }, [rules, values, validateField]);

  // ============================================================
  // 3. GÉRER LE CHANGEMENT D'UN CHAMP
  // ============================================================
  const handleChange = useCallback((e) => {
    const { name, value, type, checked } = e.target;
    const newValue = type === 'checkbox' ? checked : value;

    setValues(prev => ({ ...prev, [name]: newValue }));

    setTouched(prevTouched => {
      if (prevTouched[name] && rules && rules[name]) {
        const error = validateField(name, newValue);
        setErrors(prev => ({ ...prev, [name]: error }));
      }
      return prevTouched;
    });
  }, [rules, validateField]);

  // ============================================================
  // 4. GÉRER LE BLUR (PERDRE LE FOCUS)
  // ============================================================
  const handleBlur = useCallback((e) => {
    const { name } = e.target;
    setTouched(prev => ({ ...prev, [name]: true }));

    if (rules && rules[name]) {
      const error = validateField(name, values[name]);
      setErrors(prev => ({ ...prev, [name]: error }));
    }
  }, [rules, values, validateField]);

  // ============================================================
  // 5. DÉFINIR LA VALEUR D'UN CHAMP
  // ============================================================
  const setFieldValue = useCallback((name, value) => {
    setValues(prev => ({ ...prev, [name]: value }));

    setTouched(prevTouched => {
      if (prevTouched[name] && rules && rules[name]) {
        const error = validateField(name, value);
        setErrors(prev => ({ ...prev, [name]: error }));
      }
      return prevTouched;
    });
  }, [rules, validateField]);

  // ============================================================
  // 6. DÉFINIR PLUSIEURS VALEURS À LA FOIS
  //    -> Référence 100% stable (aucune dépendance), c'est celle qui
  //    causait la boucle infinie via ProspectForm.jsx -> loadProspect.
  // ============================================================
  const setValuesMultiple = useCallback((newValues) => {
    setValues(prev => ({ ...prev, ...newValues }));
  }, []);

  // ============================================================
  // 7. RÉINITIALISER LE FORMULAIRE
  // ============================================================
  const resetForm = useCallback(() => {
    setValues(initialValues);
    setErrors({});
    setTouched({});
  }, [initialValues]);

  // ============================================================
  // 8. EFFACER LES ERREURS D'UN CHAMP
  // ============================================================
  const clearError = useCallback((name) => {
    setErrors(prev => {
      const newErrors = { ...prev };
      delete newErrors[name];
      return newErrors;
    });
  }, []);

  return {
    values,
    errors,
    touched,
    handleChange,
    handleBlur,
    validateForm,
    setFieldValue,
    setValues: setValuesMultiple,
    resetForm,
    clearError,
    validateField,
  };
};

// ============================================================
// RÈGLES DE VALIDATION PRÉDÉFINIES
// ============================================================

export const validators = {
  required: (message = 'Ce champ est requis') => (value) => {
    if (!value || (typeof value === 'string' && !value.trim())) return message;
    return '';
  },

  email: (message = 'Email invalide') => (value) => {
    if (!value) return '';
    if (!/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i.test(value)) return message;
    return '';
  },

  phone: (message = 'Numéro de téléphone invalide (9 chiffres, commence par 6)') => (value) => {
    if (!value) return '';
    const cleanedValue = value.replace(/\s/g, '');
    if (!/^6\d{8}$/.test(cleanedValue)) return message;
    return '';
  },

  minLength: (min, message) => (value) => {
    if (!value) return '';
    if (value.length < min) return message || `Minimum ${min} caractères`;
    return '';
  },

  maxLength: (max, message) => (value) => {
    if (!value) return '';
    if (value.length > max) return message || `Maximum ${max} caractères`;
    return '';
  },

  match: (field, fieldName, message) => (value, allValues) => {
    if (!value) return '';
    if (!allValues || !allValues[field]) {
      return '';
    }
    if (value !== allValues[field]) {
      return message || `${fieldName} ne correspond pas`;
    }
    return '';
  },

  number: (message = 'Doit être un nombre') => (value) => {
    if (!value) return '';
    if (isNaN(Number(value))) return message;
    return '';
  },

  positive: (message = 'Doit être positif') => (value) => {
    if (!value) return '';
    if (Number(value) <= 0) return message;
    return '';
  },

  url: (message = 'URL invalide') => (value) => {
    if (!value) return '';
    try {
      new URL(value);
      return '';
    } catch {
      return message;
    }
  },

  min: (min, message) => (value) => {
    if (!value) return '';
    if (Number(value) < min) return message || `Minimum ${min}`;
    return '';
  },

  max: (max, message) => (value) => {
    if (!value) return '';
    if (Number(value) > max) return message || `Maximum ${max}`;
    return '';
  },
};