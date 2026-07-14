// src/components/StarRating.jsx

import React, { useState } from 'react';
import { Star } from 'lucide-react';

const StarRating = ({ 
  value = 0, 
  onChange, 
  readonly = false,
  size = 24,
  maxStars = 5
}) => {
  const [hover, setHover] = useState(0);

  const handleClick = (index) => {
    if (readonly) return;
    if (onChange) {
      onChange(index);
    }
  };

  const handleMouseEnter = (index) => {
    if (readonly) return;
    setHover(index);
  };

  const handleMouseLeave = () => {
    if (readonly) return;
    setHover(0);
  };

  return (
    <div className="star-rating" style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
      {[...Array(maxStars)].map((_, index) => {
        const starValue = index + 1;
        const isActive = starValue <= (hover || value);
        
        return (
          <Star
            key={index}
            size={size}
            onClick={() => handleClick(starValue)}
            onMouseEnter={() => handleMouseEnter(starValue)}
            onMouseLeave={handleMouseLeave}
            style={{
              cursor: readonly ? 'default' : 'pointer',
              fill: isActive ? '#f59e0b' : 'none',
              color: isActive ? '#f59e0b' : '#d1d5db',
              transition: 'all 0.2s',
              transform: hover >= starValue && !readonly ? 'scale(1.2)' : 'scale(1)',
            }}
          />
        );
      })}
      {value > 0 && (
        <span className="star-rating-label" style={{ marginLeft: '8px', fontSize: '14px', color: '#6c757d' }}>
          {value}/5
        </span>
      )}
    </div>
  );
};

export default StarRating;