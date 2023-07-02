// Initialize
document.addEventListener("DOMContentLoaded", async function() {
    const response = await fetch('/api/memos');
    const memos = await response.json();

    const ul = document.createElement('ul');
    memos.forEach(item => {
      const li = document.createElement('li');
      let a = document.createElement('a');
      a.textContent = item.title;
      a.href = `/memos/${item.id}`;
      li.appendChild(a);
      ul.appendChild(li);
    });
    document.getElementById('data-container').appendChild(ul);
});
