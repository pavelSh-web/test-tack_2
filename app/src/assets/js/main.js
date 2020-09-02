// //= ../libs/js/*.js
// //= modules/*.js

//= ../libs/js/blazy.js
//= ../libs/js/unsplash-source.js



window.addEventListener('DOMContentLoaded', () => {
    function elementSize(selector) {
        const element = document.querySelector(selector);
        return element.clientHeight;
    }
    document.querySelector('gallery').style.marginTop = elementSize('.photo-head') + 'px';

    

    
    
    // const targets = document.querySelectorAll('gallery img');
    // console.log(targets);
    // targets.forEach(target => {
    //     console.log(target);
    // });
});