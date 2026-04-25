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
  const [darkMode, setDarkMode] = useState(false);
  const [detectedCountry, setDetectedCountry] = useState('');
  const [filterByGenreFn, setFilterByGenreFn] = useState(null);
  const audioRef = useRef(null);
  
  // Detectar preferência de tema do sistema
  useEffect(() => {
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    const savedTheme = localStorage.getItem('theme');
    
    if (savedTheme === 'dark' || (!savedTheme && prefersDark)) {
      setDarkMode(true);
      document.documentElement.setAttribute('data-theme', 'dark');
    }
  }, []);

  // Alternar tema
  const toggleTheme = () => {
    const newDarkMode = !darkMode;
    setDarkMode(newDarkMode);
    
    if (newDarkMode) {
      document.documentElement.setAttribute('data-theme', 'dark');
      localStorage.setItem('theme', 'dark');
    } else {
      document.documentElement.removeAttribute('data-theme');
      localStorage.setItem('theme', 'light');
    }
  };
  
  useEffect(() => {
    if (audioRef.current) {
      audioRef.current.volume = volume / 100;
    }
  }, [volume]);

  const handleSearchResults = (results, append = false) => {
    if (append && Array.isArray(results)) {
      setAllStations(prev => [...prev, ...results]);
    } else if (typeof results === 'function') {
      // Se for uma função (callback), usamos o resultado dela
      setAllStations(results);
    } else {
      setAllStations(results.length > 0 ? results : stations);
    }
    setCurrentStation(null);
    setIsPlaying(false);
  };

  const handleLoading = (loading) => {
    setIsLoading(loading);
  };

  const handleFilterByGenre = (fn) => {
    setFilterByGenreFn(() => fn);
  };

  const handleSelectStation = (station) => {
    if (currentStation?.id === station.id) {
      handlePlayPause();
    } else {
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

  const handleFilterByGenreClick = async (genre, country) => {
    if (filterByGenreFn && country) {
      await filterByGenreFn(genre, country);
    }
  };

  return (
    <div className="app">
      <button 
        onClick={toggleTheme} 
        className="theme-toggle"
        aria-label={darkMode ? 'Ativar modo claro' : 'Ativar modo escuro'}
      >
        {darkMode ? (
          <svg viewBox="0 0 24 24" width="20" height="20">
            <path fill="currentColor" d="M12,7A5,5 0 0,1 17,12A5,5 0 0,1 12,17A5,5 0 0,1 7,12A5,5 0 0,1 12,7M12,9A3,3 0 0,0 9,12A3,3 0 0,0 12,15A3,3 0 0,0 15,12A3,3 0 0,0 12,9M12,2L14.39,5.42C13.65,5.15 12.84,5 12,5C11.16,5 10.35,5.15 9.61,5.42L12,2M3.34,7L7.5,5.29C7.24,6.03 7.09,6.84 7.09,7.69C7.09,8.54 7.24,9.35 7.5,10.09L3.34,8.38L3.34,7M3.34,17L3.34,15.62L7.5,13.91C7.24,14.65 7.09,15.46 7.09,16.31C7.09,17.16 7.24,17.97 7.5,18.71L3.34,17M12,22L9.61,18.58C10.35,18.85 11.16,19 12,19C12.84,19 13.65,18.85 14.39,18.58L12,22M20.66,17L16.5,18.71C16.76,17.97 16.91,17.16 16.91,16.31C16.91,15.46 16.76,14.65 16.5,13.91L20.66,15.62L20.66,17M20.66,7L20.66,8.38L16.5,10.09C16.76,9.35 16.91,8.54 16.91,7.69C16.91,6.84 16.76,6.03 16.5,5.29L20.66,7Z" />
          </svg>
        ) : (
          <svg viewBox="0 0 24 24" width="20" height="20">
            <path fill="currentColor" d="M17.75,4.09L15.22,6.03L16.13,9.09L13.5,7.28L10.87,9.09L11.78,6.03L9.25,4.09L12.44,4L13.5,1L14.56,4L17.75,4.09M21.25,11L19.61,12.25L20.2,14.23L18.5,13.06L16.8,14.23L17.39,12.25L15.75,11L17.81,10.95L18.5,9L19.19,10.95L21.25,11M18.97,15.95C19.8,15.87 20.69,17.05 20.16,17.8C19.84,18.25 19.5,18.67 19.08,19.07C15.17,23 8.84,23 4.94,19.07C1.03,15.17 1.03,8.83 4.94,4.93C5.34,4.53 5.76,4.17 6.21,3.85C6.96,3.32 8.14,4.21 8.06,5.04C6.83,10.25 9.75,14.75 14.96,15.97C15.16,16 15.37,16 15.57,16C16.71,16 17.82,15.99 18.97,15.95Z" />
          </svg>
        )}
      </button>

      <header className="app-header">
        <h1>📻 Web Rádio Player</h1>
        <p>Ouça rádios de todo o mundo</p>
      </header>

      <main className="app-main">
        <SearchBar 
          onSearchResults={handleSearchResults}
          onLoading={handleLoading}
          onFilterByGenre={handleFilterByGenre}
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
          onFilterByGenre={handleFilterByGenreClick}
          currentCountry={detectedCountry}
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
