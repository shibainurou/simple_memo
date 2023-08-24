// Initialize
document.addEventListener('DOMContentLoaded', async function () {
  const response = await fetch(`/api/memos/${id}`);
  const memo = await response.json();

  const id_title = this.getElementById('title');
  id_title.value = memo.title;

  const id_content = this.getElementById('content');
  id_content.value = memo.content;
});
