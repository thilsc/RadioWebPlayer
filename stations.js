async function populate() {

    const requestURL = 'https://raw.githubusercontent.com/thilsc/RadioWebPlayer/html5/stations.json';
    const request = new Request(requestURL);
    const response = await fetch(request);
    const stationsText = await response.text();
    const stations = JSON.parse(stationsText);
    const audio_section = document.getElementById("audio");
    const playlist_section = document.getElementById("playlist");


    audio_section.innerText = 'Your browser does not support HTML5 audio.';

    var i = 1;
    for (const station of stations) {

        const audio_source = document.createElement('source');

        const playlist_row = document.createElement('div');
        playlist_row.classList.add('play-list-row');
        playlist_row.setAttribute('data-track-row', i);

        const small_toggle_btn = document.createElement('div');
        const small_play_btn = document.createElement('i');
        const small_play_span = document.createElement('span');
        small_toggle_btn.classList.add('small-toggle-btn');
        small_play_btn.classList.add('small-play-btn');
        small_play_span.classList.add('screen-reader-text');
        small_play_span.innerText = 'Small toggle button';
        small_play_btn.appendChild(small_play_span);
        small_toggle_btn.appendChild(small_play_btn);

        const track_number = document.createElement('div');
        track_number.classList.add('track-number');
        track_number.innerText = i + '. ';

        const track_title = document.createElement('div');
        track_title.classList.add('track-title');
        const track_title_link = document.createElement('a');
        track_title_link.classList.add('playlist-track');
        track_title_link.setAttribute('href', '#');
        track_title_link.setAttribute('data-play-track', i);
        track_title_link.innerText = station.station_name;
        track_title.appendChild(track_title_link);

        playlist_row.appendChild(small_toggle_btn);
        playlist_row.appendChild(track_number);
        playlist_row.appendChild(track_title);

        audio_source.src = station.src;
        audio_source.setAttribute('data-track-number', i);
        i++;

        audio_section.appendChild(audio_source);

        playlist_section.appendChild(playlist_row);
    }

    var player = new audioPlayer();

    player.initPlayer();
}

populate();