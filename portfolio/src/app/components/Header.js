import React from 'react';

const Header = () => {
  return (
    <header className="header">
      <div className="logo">
        <img src="/assets/logo.jpg" alt="Logo"/>
      </div>
      <nav>
        <ul>
          <li><a href="#home">Home</a></li>
          <li><a href="#about">About Me</a></li>
          <li><a href="#services">Services</a></li>
          <li><a href="#projects">Projects</a></li>
          <li><a href="#testimonials">Testimonials</a></li>
          <li><a href="#contact">Contact</a></li>
          <li><a href="/cv.pdf" className="download-cv">Download CV</a></li>
        </ul>
      </nav>
    </header>
  );
};

export default Header;
