import React from 'react';
import { 
  LayoutDashboard, Users, User, Megaphone, MapPin, Building, 
  BookOpen, Database, Bell, BarChart3, Settings 
} from 'lucide-react';

const iconMap = {
  dashboard: LayoutDashboard,
  users: Users,
  user: User,
  campaign: Megaphone,
  affectation: MapPin,
  building: Building,
  book: BookOpen,
  source: Database,
  relance: Bell,
  stats: BarChart3,
  settings: Settings,
};

const NavItem = ({ name, icon, isActive, onClick }) => {
  const IconComponent = iconMap[icon] || LayoutDashboard;

  return (
    <div 
      className={`nav-item ${isActive ? 'active' : ''}`}
      onClick={onClick}
    >
      <IconComponent size={18} />
      <span>{name}</span>
    </div>
  );
};

export default NavItem;