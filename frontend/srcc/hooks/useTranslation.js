import { useLanguage } from '../context/LanguageContext';

export const useTranslation = () => {
  const { t, language, changeLanguage } = useLanguage();
  return { t, language, changeLanguage };
};
