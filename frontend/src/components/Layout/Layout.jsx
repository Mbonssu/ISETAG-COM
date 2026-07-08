import React, { useState } from 'react';
import Sidebar from '../Sidebar/Sidebar';
import Topbar from '../Topbar/Topbar';
import '../../App.css';

const Layout = ({ children }) => {
  const [isSidebarCollapsed, setIsSidebarCollapsed] = useState(false);

  const toggleSidebar = () => {
    setIsSidebarCollapsed(!isSidebarCollapsed);
  };

  return (
    <div className="app">
      <div className="blob3"></div>
      <div className="blob4"></div>
      <Sidebar isCollapsed={isSidebarCollapsed} />
      <main className={`main ${isSidebarCollapsed ? 'sidebar-collapsed' : 'sidebar-expanded'}`}>
        <Topbar onMenuClick={toggleSidebar} />
        <div className="content">
          {children}
        </div>
      </main>
    </div>
  );
};

export default Layout;
