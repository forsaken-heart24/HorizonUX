// hamburger menu bitch
function toggleMenu() {
    document.getElementById('sideMenu').classList.toggle('open');
}

// disables pip popup on browsers like zen motherfucker
document.addEventListener('DOMContentLoaded', () => {
    const bgVideo = document.querySelector('.bg-video');
    if('disablePictureInPicture' in bgVideo) {
        bgVideo.disablePictureInPicture = true;
    }
});