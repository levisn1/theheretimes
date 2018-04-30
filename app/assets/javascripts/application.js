//= require jquery
//= require rails-ujs
//= require_tree .

function initUpdateNavbarOnScroll() {
  const navbar = document.querySelector('.navbar-wagon');
  window.addEventListener('scroll', () => {
    if (window.scrollY >= 150) {
      navbar.classList.add('navbar-wagon-white');
    } else {
      navbar.classList.remove('navbar-wagon-white');
    }
  });
}

initUpdateNavbarOnScroll();
