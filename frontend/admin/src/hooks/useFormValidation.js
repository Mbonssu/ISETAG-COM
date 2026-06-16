import { useState } from 'react';

export const useFormValidation = (initialValues, rules) => {
  const [values, setValues] = useState(initialValues);
  const [errors, setErrors] = useState({});
  const [touched, setTouched] = useState({});

  const validateField = (name, value) => {
    const fieldRules = rules[name];
    if (!fieldRules) return '';

    for (const rule of fieldRules) {
      // Passer l'ensemble des valeurs pour la validation
      const error = rule(value, values);
      if (error) return error;
    }
    return '';
  };

  const validateForm = () => {
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
  };

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    const newValue = type === 'checkbox' ? checked : value;
    
    setValues(prev => ({ ...prev, [name]: newValue }));
    
    if (touched[name]) {
      const error = validateField(name, newValue);
      setErrors(prev => ({ ...prev, [name]: error }));
    }
  };

  const handleBlur = (e) => {
    const { name } = e.target;
    setTouched(prev => ({ ...prev, [name]: true }));
    const error = validateField(name, values[name]);
    setErrors(prev => ({ ...prev, [name]: error }));
  };

  const setFieldValue = (name, value) => {
    setValues(prev => ({ ...prev, [name]: value }));
    if (touched[name]) {
      const error = validateField(name, value);
      setErrors(prev => ({ ...prev, [name]: error }));
    }
  };

  return {
    values,
    errors,
    touched,
    handleChange,
    handleBlur,
    validateForm,
    setFieldValue,
    setValues
  };
};

// Règles de validation prédéfinies
export const validators = {
  required: (message = 'Ce champ est requis') => (value) => {
    if (!value || (typeof value === 'string' && !value.trim())) return message;
    return '';
  },
  email: (message = 'Email invalide') => (value) => {
    if (value && !/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i.test(value)) return message;
    return '';
  },
  phone: (message = 'Téléphone invalide (9-10 chiffres)') => (value) => {
    if (value && !/^[0-9]{9,10}$/.test(value.replace(/\s/g, ''))) return message;
    return '';
  },
  minLength: (min, message) => (value) => {
    if (value && value.length < min) return message || `Minimum ${min} caractères`;
    return '';
  },
  maxLength: (max, message) => (value) => {
    if (value && value.length > max) return message || `Maximum ${max} caractères`;
    return '';
  },
  match: (field, fieldName, message) => (value, allValues) => {
    // Vérifier que allValues existe et que le champ existe
    if (!allValues || !allValues[field]) {
      return '';
    }
    if (value !== allValues[field]) {
      return message || `${fieldName} ne correspond pas`;
    }
    return '';
  },
  number: (message = 'Doit être un nombre') => (value) => {
    if (value && isNaN(Number(value))) return message;
    return '';
  },
  positive: (message = 'Doit être positif') => (value) => {
    if (value && Number(value) <= 0) return message;
    return '';
  }
};
