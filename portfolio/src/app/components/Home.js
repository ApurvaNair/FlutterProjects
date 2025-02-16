import React from 'react';

const Home = () => {
  return (
    <section id="home" className="hero">
      <div className="hero-content">
        <div className="intro">
          <p className="greeting">Hi, I'm</p>
          <h1>Muhammad Umair</h1>
          <h2>UI & UX Designer</h2>
          <p className="description">
            Lorem ipsum dolor sit amet consectetur. Tristique amet sed massa
            nibh lectus netus in. Aliquet donec morbi convallis pretium. Turpis tempus pharetra.
          </p>
          <button className="hire-me">Hire Me</button>
        </div>
        <div className="profile-pic">
          <img src="assets/profile.jpg" alt="Profile Picture" />
        </div>
      </div>
      <div className="social-links">
        <a href="https://facebook.com"><img src='fb.jpg'></img></a>
        <a href="https://twitter.com"><img src='twt.jpg'></img></a>
        <a href="https://instagram.com"><img src='ig.jpg'></img></a>
        <a href="https://linkedin.com"><img src='in.jpg'></img></a>
      </div>
    </section>
  );
};

export default Home;
