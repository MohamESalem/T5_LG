document.addEventListener('DOMContentLoaded', () => {
    const footerText = document.getElementById('footer-text');
    const words = footerText.textContent.split(' ');
    footerText.textContent = '';
    let delay = 500; 

    function addWord(index) {
        if (index >= words.length) return;

        const span = document.createElement('span');
        span.textContent = words[index] + ' ';
        span.style.opacity = 0;
        span.style.transform = 'scale(0.5)';
        span.style.transition = `opacity 0.5s ease-out, transform 0.5s ease-out, color 0.5s ease-out`;
        footerText.appendChild(span);

        requestAnimationFrame(() => {
            span.style.opacity = 1;
            span.style.transform = 'scale(1)';
            checkOverflow();
            setTimeout(() => addWord(index + 1), delay);
        });
    }

    function checkOverflow() {
        while (footerText.scrollWidth > footerText.clientWidth) {
            footerText.removeChild(footerText.firstChild);
        }
    }

    addWord(0);
});
