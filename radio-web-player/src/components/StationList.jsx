import React from 'react';
import './StationList.css';

const StationList = ({ stations, currentStation, onSelectStation }) => {
  return (
    <div className="station-list-container">
      <h2 className="list-title">Estações de Rádio</h2>
      <div className="station-list">
        {stations.map((station) => (
          <div
            key={station.id}
            className={`station-item ${currentStation?.id === station.id ? 'active' : ''}`}
            onClick={() => onSelectStation(station)}
          >
            <div className="station-item-logo">
              <img 
                src={station.logo} 
                alt={station.name}
                onError={(e) => {
                  e.target.src = 'https://via.placeholder.com/60x60?text=Radio';
                }}
              />
            </div>
            <div className="station-item-info">
              <h3 className="station-item-name">{station.name}</h3>
              <p className="station-item-frequency">{station.frequency}</p>
              <span className="station-item-genre">{station.genre}</span>
            </div>
            {currentStation?.id === station.id && (
              <div className="playing-indicator">
                <div className="dot"></div>
                <span>Tocando</span>
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
};

export default StationList;
