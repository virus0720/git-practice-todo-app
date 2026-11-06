// 我的待辦清單：資料存在瀏覽器的 localStorage，重新整理也不會不見
const STORAGE_KEY = 'todo-app-items';

const form = document.getElementById('todo-form');
const input = document.getElementById('todo-input');
const list = document.getElementById('todo-list');
const count = document.getElementById('todo-count');

let todos = load();

function load() {
  try {
    return JSON.parse(localStorage.getItem(STORAGE_KEY)) || [];
  } catch {
    return [];
  }
}

function save() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(todos));
}

function addTodo(text) {
  todos.push({ id: Date.now(), text, done: false });
  save();
  render();
}

function toggleTodo(id) {
  const todo = todos.find((t) => t.id === id);
  if (todo) todo.done = !todo.done;
  save();
  render();
}

function removeTodo(id) {
  todos = todos.filter((t) => t.id !== id);
  save();
  render();
}

// 決定清單上要顯示哪些項目
function visibleTodos() {
  return todos;
}

function render() {
  list.innerHTML = '';
  for (const todo of visibleTodos()) {
    const item = document.createElement('li');
    item.className = todo.done ? 'todo done' : 'todo';

    const label = document.createElement('label');
    const checkbox = document.createElement('input');
    checkbox.type = 'checkbox';
    checkbox.checked = todo.done;
    checkbox.addEventListener('change', () => toggleTodo(todo.id));
    const text = document.createElement('span');
    text.textContent = todo.text;
    label.append(checkbox, text);

    const remove = document.createElement('button');
    remove.className = 'remove';
    remove.textContent = '刪除';
    remove.setAttribute('aria-label', `刪除「${todo.text}」`);
    remove.addEventListener('click', () => removeTodo(todo.id));

    item.append(label, remove);
    list.append(item);
  }

  const left = todos.filter((t) => !t.done).length;
  count.textContent = todos.length === 0 ? '清單是空的，新增第一件事吧' : `還有 ${left} 件事沒完成`;
}

form.addEventListener('submit', (event) => {
  event.preventDefault();
  const text = input.value.trim();
  if (!text) return;
  addTodo(text);
  input.value = '';
  input.focus();
});

render();
