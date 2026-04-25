import { useState, useEffect, useRef } from 'react';
import RadioPlayer from './components/RadioPlayer';
import StationList from './components/StationList';
import SearchBar from './components/SearchBar';
import stations from './data/stations';
import './App.css';

function App() {
  const [currentStation, setCurrentStation] = useState(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [volume, setVolume] = useState(75);
  const [allStations, setAllStations] = useState(stations);
  const [isLoading, setIsLoading] = useState(false);
  const audioRef = useRef(null);
  
  useEffect(() => {
    if (audioRef.current) {
      audioRef.current.volume = volume / 100;
    }
  }, [volume]);

  const handleSearchResults = (results) => {
    setAllStations(results.length > 0 ? results : stations);
    setCurrentStation(null);
    setIsPlaying(false);
  };

  const handleLoading = (loading) => {
    setIsLoading(loading);
  };

  const handleSelectStation = (station) => {
    if (currentStation?.id === station.id) {
      // Same station, toggle play/pause
      handlePlayPause();
    } else {
      // New station
      setCurrentStation(station);
      setIsPlaying(true);
    }
  };

  const handlePlayPause = () => {
    if (!currentStation) return;
    
    if (isPlaying) {
      if (audioRef.current) {
        audioRef.current.pause();
      }
      setIsPlaying(false);
    } else {
      if (audioRef.current) {
        audioRef.current.play().catch(error => {
          console.error('Error playing audio:', error);
          setIsPlaying(false);
        });
      }
      setIsPlaying(true);
    }
  };

  const handleVolumeChange = (newVolume) => {
    setVolume(newVolume);
  };

  return (
    <div className="app">
      <header className="app-header">
        <h1>📻 Web Rádio Player</h1>
        <p>Ouça rádios de todo o mundo</p>
      </header>

      <main className="app-main">
        <SearchBar 
          onSearchResults={handleSearchResults}
          onLoading={handleLoading}
        />

        {isLoading && (
          <div className="loading-indicator">
            <div className="spinner"></div>
            <p>Buscando estações...</p>
          </div>
        )}

        <RadioPlayer
          currentStation={currentStation}
          isPlaying={isPlaying}
          onPlayPause={handlePlayPause}
          volume={volume}
          onVolumeChange={handleVolumeChange}
        />

        <StationList
          stations={allStations}
          currentStation={currentStation}
          onSelectStation={handleSelectStation}
        />
      </main>

      {/* Hidden audio element */}
      {currentStation && (
        <audio
          ref={audioRef}
          src={currentStation.streamUrl}
          onPlay={() => setIsPlaying(true)}
          onPause={() => setIsPlaying(false)}
          onError={(e) => {
            console.error('Audio error:', e);
            setIsPlaying(false);
          }}
          autoPlay={isPlaying}
        />
      )}

      <footer className="app-footer">
        <p>Desenvolvido com React.js ❤️</p>
      </footer>
    </div>
  );
}

export default App;
