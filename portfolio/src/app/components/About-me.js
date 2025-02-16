import React from 'react';

const AboutMe = () => {
  return (
    <div className="about-container">
      <div className="image-container">
        <img
          src="/assets/about.jpg"
          alt="Profile Image"/>
      </div>
      <div className="content">
        <h2>About Me</h2>
        <p>
          Lorem ipsum dolor sit amet consectetur. Tristique amet sed massa nibh lectus netus in.
          Aliquet donec morbi convallis pretium. Turpis tempus pharetra.
        </p>
        <div className="skills">
          <SkillBar skill="UX" level="90%" />
          <SkillBar skill="Website Design" level="70%" />
          <SkillBar skill="App Design" level="80%" />
          <SkillBar skill="Graphic Design" level="85%" />
        </div>
      </div>
    </div>
  );
};

const SkillBar = ({ skill, level }) => {
  return (
    <div className="skill-bar">
      <span>{skill}</span>
      <div className="bar">
        <div className="progress" style={{ width: level }}>
        <div className="eclipse"></div>
        </div>
      </div>
    </div>
  );
};

export default AboutMe;
