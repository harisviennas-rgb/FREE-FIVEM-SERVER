// script.js (NUI)
(function(){
  const panel = document.getElementById('adminPanel')
  const closeBtn = document.getElementById('closeBtn')
  closeBtn.addEventListener('click', ()=>{
    panel.classList.add('hidden')
    fetch(`https://${GetParentResourceName()}/close`, { method: 'POST' }).catch(()=>{})
  })

  window.addEventListener('message', function(event) {
    const data = event.data;
    if (data.action === 'openAdmin') {
      panel.classList.remove('hidden');
    } else if (data.action === 'notify') {
      alert(data.message)
    }
  });

  // Hook buttons
  document.querySelectorAll('#adminPanel button[data-action]').forEach(btn=>{
    btn.addEventListener('click', ()=>{
      const action = btn.getAttribute('data-action')
      const data = { action }
      // collect inputs
      data.target = document.getElementById('targetId')?.value || ''
      data.payload = {}
      data.payload.reason = document.getElementById('reason')?.value || ''
      data.payload.amount = document.getElementById('amount')?.value || 0
      data.payload.coords = (document.getElementById('coords')?.value || '').split(',')
      data.payload.model = document.getElementById('vehicleModel')?.value || ''
      data.payload.job = document.getElementById('jobName')?.value || ''
      data.payload.grade = document.getElementById('jobGrade')?.value || '0'

      fetch(`https://${GetParentResourceName()}/adminAction`, { method: 'POST', body: JSON.stringify(data) }).then(resp => resp.json()).then(res=>{})
    })
  })
})();
