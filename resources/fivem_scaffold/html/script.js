// script.js (NUI)
(function(){
  const panel = document.getElementById('adminPanel')
  const closeBtn = document.getElementById('closeBtn')
  closeBtn.addEventListener('click', ()=>{
    panel.classList.add('hidden')
    fetch(`https://${GetParentResourceName()}/close`, { method: 'POST' }).catch(()=>{})
  })

  const storePanel = document.getElementById('storePanel')
  const closeStore = document.getElementById('closeStore')
  closeStore.addEventListener('click', ()=>{
    storePanel.classList.add('hidden')
    fetch(`https://${GetParentResourceName()}/close`, { method: 'POST' }).catch(()=>{})
  })

  window.addEventListener('message', function(event) {
    const data = event.data;
    if (data.action === 'openAdmin') {
      panel.classList.remove('hidden');
    } else if (data.action === 'notify') {
      alert(data.message)
    } else if (data.action === 'openStore') {
      // show store UI
      const store = data.store || { name: 'Store', items: [] }
      document.getElementById('storeTitle').innerText = store.name
      const body = document.getElementById('storeBody')
      body.innerHTML = ''
      (store.items||[]).forEach(item=>{
        const el = document.createElement('div')
        el.className = 'storeItem'
        el.innerHTML = `<div><strong>${item.label}</strong><div style="font-size:0.9em;color:#ccc">$${item.price}</div></div>`
        const btn = document.createElement('button')
        btn.innerText = 'Buy'
        btn.addEventListener('click', ()=>{
          fetch(`https://${GetParentResourceName()}/buyItem`, { method: 'POST', body: JSON.stringify({ storeId: store.id, itemName: item.name }) }).then(r=>r.json()).then(()=>{})
        })
        el.appendChild(btn)
        body.appendChild(el)
      })
      storePanel.classList.remove('hidden')
    }
  });

  // Hook admin buttons
  document.querySelectorAll('#adminPanel button[data-action]').forEach(btn=>{
    btn.addEventListener('click', ()=>{
      const action = btn.getAttribute('data-action')
      const data = { action }
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
