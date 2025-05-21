// this motherfucker will play the score for us if the fucking browser allows it.
document.addEventListener("DOMContentLoaded", () => {
    const music = document.getElementById("bg-music");
    if(music) {
        music.play().catch(() => {
            console.log("Music autoplay is blocked by this motherfucking browser");
        });
    }
});

// this motherfucker will handle play and pause.
document.addEventListener("DOMContentLoaded", () => {
    const music = document.getElementById("bg-music");
    const button = document.getElementById("toggle-music");
    let isPlaying = false;
    button.addEventListener("click", () => {
        if(isPlaying) {
            music.pause();
            button.textContent = "Play Ambience";
        }
        else {
            music.play();
            button.textContent = "Pause Ambience";
        }
        isPlaying = !isPlaying;
    });
});

// hamburger menu bitch
function toggleMenu() {
    document.getElementById('sideMenu').classList.toggle('open');
}

// disables pip popup on browsers like zen motherfucker
document.addEventListener('DOMContentLoaded', () => {
    const bgVideo = document.querySelector('.bg-video');
    if ('disablePictureInPicture' in bgVideo) {
        bgVideo.disablePictureInPicture = true;
    }
});