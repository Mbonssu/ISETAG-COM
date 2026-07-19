export const matchesDateRange = (dateValue, startDate, endDate) => {
  if (!dateValue) {
    return false;
  }

  if (!startDate && !endDate) {
    return true;
  }

  const date = new Date(dateValue);

  if (Number.isNaN(date.getTime())) {
    return false;
  }

  const normalizedStart = startDate ? new Date(`${startDate}T00:00:00`) : null;
  const normalizedEnd = endDate ? new Date(`${endDate}T23:59:59`) : null;

  if (normalizedStart && date < normalizedStart) {
    return false;
  }

  if (normalizedEnd && date > normalizedEnd) {
    return false;
  }

  return true;
};
