import { useState, useEffect } from 'react';

export const usePagination = (items, defaultItemsPerPage = 10) => {
  const [currentPage, setCurrentPage] = useState(1);
  const [itemsPerPage, setItemsPerPage] = useState(defaultItemsPerPage);

  // Détection de la taille d'écran pour ajuster le nombre de lignes
  useEffect(() => {
    const updateItemsPerPage = () => {
      const width = window.innerWidth;
      const height = window.innerHeight;
      
      // Sur les grands écrans (>= 1600px de large ou >= 900px de haut)
      if (width >= 1600 || height >= 900) {
        setItemsPerPage(12);
      } 
      // Écrans moyens
      else if (width >= 1200 || height >= 700) {
        setItemsPerPage(10);
      }
      // Petits écrans
      else {
        setItemsPerPage(8);
      }
    };

    updateItemsPerPage();
    window.addEventListener('resize', updateItemsPerPage);
    return () => window.removeEventListener('resize', updateItemsPerPage);
  }, []);

  const totalPages = Math.ceil(items.length / itemsPerPage);
  
  // S'assurer que la page courante est valide après changement du nombre d'éléments
  useEffect(() => {
    if (currentPage > totalPages && totalPages > 0) {
      setCurrentPage(totalPages);
    }
  }, [totalPages, currentPage]);

  const paginatedItems = items.slice(
    (currentPage - 1) * itemsPerPage,
    currentPage * itemsPerPage
  );

  const goToPage = (page) => {
    if (page >= 1 && page <= totalPages) {
      setCurrentPage(page);
    }
  };

  const nextPage = () => goToPage(currentPage + 1);
  const prevPage = () => goToPage(currentPage - 1);

  return {
    currentPage,
    totalPages,
    itemsPerPage,
    paginatedItems,
    goToPage,
    nextPage,
    prevPage,
    setCurrentPage
  };
};
