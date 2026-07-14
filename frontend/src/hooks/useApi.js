import { useState, useEffect, useCallback } from 'react';
import { useAuth } from '../context/AuthContext';

export const useApi = (serviceMethod, params = null, immediate = true) => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const { logout } = useAuth();

  const execute = useCallback(async (methodParams = params) => {
    setLoading(true);
    setError(null);
    try {
      const response = await serviceMethod(methodParams);
      setData(response.data);
      return response.data;
    } catch (err) {
      if (err.status === 401) {
        logout();
      }
      setError(err.message);
      throw err;
    } finally {
      setLoading(false);
    }
  }, [serviceMethod, logout]);

  useEffect(() => {
    if (immediate) {
      execute();
    }
  }, [execute, immediate]);

  return { data, loading, error, execute, setData };
};

// Pour les requêtes avec pagination
export const usePaginatedApi = (serviceMethod, initialParams = {}) => {
  const [items, setItems] = useState([]);
  const [totalItems, setTotalItems] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [itemsPerPage, setItemsPerPage] = useState(10);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const { logout } = useAuth();

  const fetchData = useCallback(async (page = currentPage, params = {}) => {
    setLoading(true);
    setError(null);
    try {
      const response = await serviceMethod({
        page,
        limit: itemsPerPage,
        ...initialParams,
        ...params
      });
      setItems(response.data.items || []);
      setTotalItems(response.data.total || 0);
      return response.data;
    } catch (err) {
      if (err.status === 401) {
        logout();
      }
      setError(err.message);
      throw err;
    } finally {
      setLoading(false);
    }
  }, [serviceMethod, itemsPerPage, initialParams, logout]);

  const goToPage = (page) => {
    setCurrentPage(page);
    fetchData(page);
  };

  useEffect(() => {
    fetchData(1);
  }, []);

  return {
    items,
    totalItems,
    currentPage,
    itemsPerPage,
    setItemsPerPage,
    loading,
    error,
    fetchData,
    goToPage
  };
};
