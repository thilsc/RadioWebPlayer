import { useState, useEffect } from 'react';
import './SearchBar.css';

const SearchBar = ({ onSearchResults, onLoading, onFilterByGenre }) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCountry, setSelectedCountry] = useState('');
  const [selectedTag, setSelectedTag] = useState('');
  const [countries, setCountries] = useState([]);
  const [tags, setTags] = useState([]);
  const [showFilters, setShowFilters] = useState(false);
  const [detectedCountry, setDetectedCountry] = useState('');
  const [isDetecting, setIsDetecting] = useState(true);
  const [offset, setOffset] = useState(0);
  const [hasMore, setHasMore] = useState(false);
  const [isLoadingMore, setIsLoadingMore] = useState(false);
  const limit = 50;
  
  // Detectar país do usuário via geolocalização IP
  useEffect(() => {
    const detectUserCountry = async () => {
      try {
        const response = await fetch('https://ipapi.co/json/');
        if (response.ok) {
          const data = await response.json();
          if (data.country_name) {
            setDetectedCountry(data.country_name);
            setSelectedCountry(data.country_name);
            // Auto-buscar estações do país do usuário
            performSearchByCountry(data.country_name, 0);
          } else {
            setIsDetecting(false);
          }
        } else {
          setIsDetecting(false);
        }
      } catch (error) {
        console.error('Erro ao detectar localização:', error);
        setIsDetecting(false);
      }
    };

    detectUserCountry();
  }, []);
  
  // Carregar países e tags ao iniciar
  useEffect(() => {
    const fetchCountries = async () => {
      try {
        const response = await fetch('https://de1.api.radio-browser.info/json/countries');
        if (response.ok) {
          const data = await response.json();
          const sortedCountries = data
            .sort((a, b) => b.stationcount - a.stationcount)
            .slice(0, 50)
            .map(c => c.name);
          setCountries(sortedCountries);
        }
      } catch (error) {
        console.error('Erro ao carregar países:', error);
      }
    };

    const fetchTags = async () => {
      try {
        const response = await fetch('https://de1.api.radio-browser.info/json/tags/top/50');
        if (response.ok) {
          const data = await response.json();
          setTags(data.map(t => t.name));
        }
      } catch (error) {
        console.error('Erro ao carregar tags:', error);
      }
    };

    fetchCountries();
    fetchTags();
  }, []);

  // Função de busca por país (para geolocalização automática)
  const performSearchByCountry = async (country, offsetValue = 0, append = false) => {
    if (!append) {
      onLoading(true);
      setOffset(0);
    } else {
      setIsLoadingMore(true);
    }
    
    try {
      let url = `https://de1.api.radio-browser.info/json/stations/bycountry/${encodeURIComponent(country)}?`;
      const params = [];

      params.push('order=votes');
      params.push('reverse=true');
      params.push(`limit=${limit}`);
      params.push(`offset=${offsetValue}`);
      params.push('hidebroken=true');

      url += params.join('&');

      const response = await fetch(url);
      
      if (response.ok) {
        const stations = await response.json();
        
        const formattedStations = stations
          .filter(station => station.url_resolved)
          .map((station, index) => ({
            id: station.stationuuid || `${index}-${offsetValue}`,
            name: station.name,
            frequency: station.bitrate ? `${station.bitrate} kbps` : 'Online',
            streamUrl: station.url_resolved,
            logo: station.favicon || `https://ui-avatars.com/api/?name=${encodeURIComponent(station.name)}&background=random&size=128`,
            genre: station.tags.split(',')[0] || 'Geral',
            country: station.country,
            votes: station.votes,
            language: station.language || 'Unknown'
          }))
          .sort((a, b) => b.votes - a.votes);

        if (append) {
          // Adicionar às estações existentes
          onSearchResults(prev => [...prev, ...formattedStations], true);
        } else {
          onSearchResults(formattedStations);
        }
        
        setHasMore(stations.length === limit);
      } else {
        if (!append) {
          onSearchResults([]);
        }
        setHasMore(false);
      }
    } catch (error) {
      console.error('Erro na busca:', error);
      if (!append) {
        onSearchResults([]);
      }
      setHasMore(false);
    } finally {
      onLoading(false);
      setIsDetecting(false);
      setIsLoadingMore(false);
    }
  };

  // Função de busca geral
  const performSearch = async (offsetValue = 0, append = false) => {
    if (!append) {
      onLoading(true);
      setOffset(0);
    } else {
      setIsLoadingMore(true);
    }
    
    try {
      let url = 'https://de1.api.radio-browser.info/json/stations/search?';
      const params = [];

      if (searchTerm.trim()) {
        params.push(`name=${encodeURIComponent(searchTerm.trim())}`);
      }

      if (selectedCountry) {
        params.push(`country=${encodeURIComponent(selectedCountry)}`);
      }

      if (selectedTag) {
        params.push(`tag=${encodeURIComponent(selectedTag)}`);
      }

      params.push('order=votes');
      params.push('reverse=true');
      params.push(`limit=${limit}`);
      params.push(`offset=${offsetValue}`);
      params.push('hidebroken=true');

      url += params.join('&');

      const response = await fetch(url);
      
      if (response.ok) {
        const stations = await response.json();
        
        const formattedStations = stations
          .filter(station => station.url_resolved)
          .map((station, index) => ({
            id: station.stationuuid || `${index}-${offsetValue}`,
            name: station.name,
            frequency: station.bitrate ? `${station.bitrate} kbps` : 'Online',
            streamUrl: station.url_resolved,
            logo: station.favicon || `https://ui-avatars.com/api/?name=${encodeURIComponent(station.name)}&background=random&size=128`,
            genre: station.tags.split(',')[0] || 'Geral',
            country: station.country,
            votes: station.votes,
            language: station.language || 'Unknown'
          }))
          .sort((a, b) => b.votes - a.votes);

        if (append) {
          onSearchResults(prev => [...prev, ...formattedStations], true);
        } else {
          onSearchResults(formattedStations);
        }
        
        setHasMore(stations.length === limit);
      } else {
        if (!append) {
          onSearchResults([]);
        }
        setHasMore(false);
      }
    } catch (error) {
      console.error('Erro na busca:', error);
      if (!append) {
        onSearchResults([]);
      }
      setHasMore(false);
    } finally {
      onLoading(false);
      setIsLoadingMore(false);
    }
  };

  // Função para carregar mais estações
  const loadMore = () => {
    const newOffset = offset + limit;
    setOffset(newOffset);
    
    if (selectedCountry && !searchTerm && !selectedTag) {
      performSearchByCountry(selectedCountry, newOffset, true);
    } else {
      performSearch(newOffset, true);
    }
  };

  // Filtrar por gênero no país atual
  const handleFilterByGenre = async (genre, country) => {
    if (!country) return;
    
    onLoading(true);
    setSearchTerm('');
    setSelectedTag(genre);
    setShowFilters(true);
    
    try {
      let url = `https://de1.api.radio-browser.info/json/stations/bycountry/${encodeURIComponent(country)}?`;
      const params = [];

      params.push(`tag=${encodeURIComponent(genre)}`);
      params.push('order=votes');
      params.push('reverse=true');
      params.push(`limit=${limit}`);
      params.push('hidebroken=true');

      url += params.join('&');

      const response = await fetch(url);
      
      if (response.ok) {
        const stations = await response.json();
        
        const formattedStations = stations
          .filter(station => station.url_resolved)
          .map((station, index) => ({
            id: station.stationuuid || index,
            name: station.name,
            frequency: station.bitrate ? `${station.bitrate} kbps` : 'Online',
            streamUrl: station.url_resolved,
            logo: station.favicon || `https://ui-avatars.com/api/?name=${encodeURIComponent(station.name)}&background=random&size=128`,
            genre: station.tags.split(',')[0] || 'Geral',
            country: station.country,
            votes: station.votes,
            language: station.language || 'Unknown'
          }))
          .sort((a, b) => b.votes - a.votes);

        onSearchResults(formattedStations);
        setHasMore(stations.length === limit);
      } else {
        onSearchResults([]);
        setHasMore(false);
      }
    } catch (error) {
      console.error('Erro ao filtrar por gênero:', error);
      onSearchResults([]);
      setHasMore(false);
    } finally {
      onLoading(false);
    }
  };

  // Expor handleFilterByGenre para o componente pai
  useEffect(() => {
    if (onFilterByGenre) {
      onFilterByGenre(handleFilterByGenre);
    }
  }, [detectedCountry]);

  // Buscar ao pressionar Enter
  const handleKeyPress = (e) => {
    if (e.key === 'Enter') {
      performSearch();
    }
  };

  // Limpar filtros
  const clearFilters = () => {
    setSearchTerm('');
    setSelectedCountry('');
    setSelectedTag('');
    setOffset(0);
    onSearchResults([]);
  };

  return (
    <div className="search-bar-container">
      <div className="search-main">
        <div className="search-input-wrapper">
          <svg className="search-icon" viewBox="0 0 24 24" width="20" height="20">
            <path fill="currentColor" d="M9.5,3A6.5,6.5 0 0,1 16,9.5C16,11.11 15.41,12.59 14.44,13.73L14.71,14H15.5L20.5,19L19,20.5L14,15.5V14.71L13.73,14.44C12.59,15.41 11.11,16 9.5,16A6.5,6.5 0 0,1 3,9.5A6.5,6.5 0 0,1 9.5,3M9.5,5C7,5 5,7 5,9.5C5,12 7,14 9.5,14C12,14 14,12 14,9.5C14,7 12,5 9.5,5Z" />
          </svg>
          <input
            type="text"
            placeholder={isDetecting ? "Detectando sua localização..." : detectedCountry ? `Rádios de ${detectedCountry}` : "Buscar rádios por nome..."}
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            onKeyPress={handleKeyPress}
            className="search-input"
            disabled={isDetecting}
          />
        </div>
        
        <button 
          onClick={() => setShowFilters(!showFilters)}
          className={`filter-toggle ${showFilters ? 'active' : ''}`}
        >
          <svg viewBox="0 0 24 24" width="20" height="20">
            <path fill="currentColor" d="M14,12V19.88C14.04,20.18 13.94,20.5 13.71,20.7C13.32,21.09 12.69,21.09 12.3,20.7L10.29,18.7C10.06,18.5 9.96,18.13 10,17.87V12H9.97L4.21,4.62C3.87,4.19 3.95,3.56 4.38,3.22C4.57,3.08 4.78,3 5,3V3H19V3C19.22,3 19.43,3.08 19.62,3.22C20.05,3.56 20.13,4.19 19.79,4.62L14.03,12H14Z" />
          </svg>
          Filtros
        </button>
        
        <button onClick={performSearch} className="search-btn">
          Buscar
        </button>
      </div>

      {showFilters && (
        <div className="filters-panel">
          <div className="filter-group">
            <label htmlFor="country-filter">País</label>
            <select
              id="country-filter"
              value={selectedCountry}
              onChange={(e) => setSelectedCountry(e.target.value)}
            >
              <option value="">Todos os países</option>
              {countries.map((country) => (
                <option key={country} value={country}>
                  {country}
                </option>
              ))}
            </select>
          </div>

          <div className="filter-group">
            <label htmlFor="tag-filter">Estilo Musical</label>
            <select
              id="tag-filter"
              value={selectedTag}
              onChange={(e) => setSelectedTag(e.target.value)}
            >
              <option value="">Todos os estilos</option>
              {tags.map((tag) => (
                <option key={tag} value={tag}>
                  {tag}
                </option>
              ))}
            </select>
          </div>

          <button onClick={clearFilters} className="clear-filters-btn">
            Limpar Filtros
          </button>
        </div>
      )}
      
      {detectedCountry && !isDetecting && (
        <div className="location-indicator">
          <svg viewBox="0 0 24 24" width="16" height="16">
            <path fill="currentColor" d="M12,2A7,7 0 0,1 19,9C19,14.25 12,22 12,22C12,22 5,14.25 5,9A7,7 0 0,1 12,2M12,4A5,5 0 0,0 7,9C7,11.38 8.9,13.39 12,17.5C15.1,13.39 17,11.38 17,9A5,5 0 0,0 12,4M12,6A3,3 0 0,1 15,9A3,3 0 0,1 12,12A3,3 0 0,1 9,9A3,3 0 0,1 12,6Z" />
          </svg>
          <span>Mostrando rádios de: <strong>{detectedCountry}</strong></span>
          <button onClick={() => { setDetectedCountry(''); setSelectedCountry(''); }} className="clear-location">
            <svg viewBox="0 0 24 24" width="14" height="14">
              <path fill="currentColor" d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" />
            </svg>
          </button>
        </div>
      )}
      
      {hasMore && (
        <div className="load-more-container">
          <button 
            onClick={loadMore} 
            className="load-more-btn"
            disabled={isLoadingMore}
          >
            {isLoadingMore ? 'Carregando...' : 'Carregar Mais'}
          </button>
        </div>
      )}
    </div>
  );
};

export default SearchBar;
