// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails';
import 'controllers';
import 'preline';

document.addEventListener('turbo:load', () => {
  const btn = document.getElementById('menu-button');
  const menu = document.getElementById('account-menu-dropdown');

  if (btn && menu) {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      menu.classList.toggle('hidden');
      btn.setAttribute(
        'aria-expanded',
        menu.classList.contains('hidden') ? 'false' : 'true'
      );
    });

    // 外をクリックしたら閉じる
    document.addEventListener('click', (event) => {
      if (!btn.contains(event.target) && !menu.contains(event.target)) {
        menu.classList.add('hidden');
        btn.setAttribute('aria-expanded', 'false');
      }
    });
  }
});
