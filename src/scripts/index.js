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

// faq hamburger menu bullshit.
document.addEventListener('DOMContentLoaded', () => {
    const hamburger = document.querySelector('.hamburger');
    const nav = document.getElementById('main-nav');
    function toggleMenu(open) {
        nav.classList.toggle('open', open);
        hamburger.classList.toggle('open', open);
    }
    hamburger.addEventListener('click', () => {
        const isOpen = nav.classList.contains('open');
        toggleMenu(!isOpen);
    });
    hamburger.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' || e.key === ' ') {
            e.preventDefault();
            const isOpen = nav.classList.contains('open');
            toggleMenu(!isOpen);
        }
    });
    function handleOutsideInteraction(e) {
        if (nav.classList.contains('open') && !nav.contains(e.target) && !hamburger.contains(e.target)) {
            toggleMenu(false);
        }
    }
    document.addEventListener('mousedown', handleOutsideInteraction);
    document.addEventListener('touchstart', handleOutsideInteraction);
});