// Initialize
document.addEventListener('DOMContentLoaded', async function () {
  const response = await fetch(`/api/memos/${id}`);
  const memo = await response.json();

  const id_title = this.getElementById('title');
  id_title.value = memo.title;

  const id_content = this.getElementById('content');
  id_content.value = memo.content;
});

// Edit Click
window.addEventListener('DOMContentLoaded', () => {
  const submitButton = document.getElementById('edit_button');
  submitButton.addEventListener('click', (event) => {
    event.preventDefault();

    const id_title = document.getElementById('title');
    id_title.removeAttribute('disabled');

    const id_content = document.getElementById('content');
    id_content.removeAttribute('disabled');

    const save_button = document.getElementById('save_button');
    save_button.removeAttribute('hidden');

    const edit_button = document.getElementById('edit_button');
    edit_button.setAttribute('type', 'hidden');
  });
});
