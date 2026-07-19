// script.js (NUI)
window.addEventListener('message', function(event) {
  const data = event.data;
  if (data.action === 'openMenu') {
    document.getElementById('adminPanel').classList.remove('hidden');
  }
});

// Close admin panel on Escape
document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape') {
    document.getElementById('adminPanel').classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/close`) // placeholder
  }
});
