import React from 'react';
import './RadioPlayer.css';

const RadioPlayer = ({ currentStation, isPlaying, onPlayPause, volume, onVolumeChange }) => {
  return (
    <div className="radio-player">
      <div className="player-header">
        <div className="station-info">
          {currentStation ? (
            <>
              <div className="station-logo">
                <img 
                  src={currentStation.logo} 
                  alt={currentStation.name}
                  onError={(e) => {
                    e.target.src = 'https://via.placeholder.com/100x100?text=Radio';
                  }}
                />
              </div>
              <div className="station-details">
                <h2 className="station-name">{currentStation.name}</h2>
                <p className="station-frequency">{currentStation.frequency}</p>
                <p className="station-genre">{currentStation.genre}</p>
              </div>
            </>
          ) : (
            <div className="no-station">
              <h2>Selecione uma rádio</h2>
              <p>Escolha uma estação da lista para começar a ouvir</p>
            </div>
          )}
        </div>
      </div>

      <div className="player-controls">
        <button 
          className={`play-pause-btn ${isPlaying ? 'playing' : ''}`}
          onClick={onPlayPause}
          disabled={!currentStation}
        >
          {isPlaying ? (
            <svg viewBox="0 0 24 24" width="32" height="32">
              <path fill="currentColor" d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/>
            </svg>
          ) : (
            <svg viewBox="0 0 24 24" width="32" height="32">
              <path fill="currentColor" d="M8 5v14l11-7z"/>
            </svg>
          )}
        </button>

        <div className="volume-control">
          <svg viewBox="0 0 24 24" width="24" height="24">
            <path fill="currentColor" d="M3 9v6h4l5 5V4L7 9H3zm13.5 3c0-1.77-1.02-3.29-2.5-4.03v8.05c1.48-.73 2.5-2.25 2.5-4.02zM14 3.23v2.06c2.89.86 5 3.54 5 6.71s-2.11 5.85-5 6.71v2.06c4.01-.91 7-4.49 7-8.77s-2.99-7.86-7-8.77z"/>
          </svg>
          <input
            type="range"
            min="0"
            max="100"
            value={volume}
            onChange={(e) => onVolumeChange(parseInt(e.target.value))}
            className="volume-slider"
          />
          <span className="volume-value">{volume}%</span>
        </div>
      </div>

      {isPlaying && (
        <div className="visualizer">
          <div className="bar"></div>
          <div className="bar"></div>
          <div className="bar"></div>
          <div className="bar"></div>
          <div className="bar"></div>
        </div>
      )}
    </div>
  );
};

export default RadioPlayer;
