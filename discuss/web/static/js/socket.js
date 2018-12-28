import {Socket} from "phoenix"
let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

const createSocket = (topicId) => {

  let channel = socket.channel('comments:' + topicId, {})
  channel.join()
    .receive("ok", resp => { renderComments(resp.comments) })
    .receive("error", resp => { console.log("Unable to join", resp) })
  
  document.querySelector('button').addEventListener('click', function(e) {
    e.preventDefault()
    const textarea = document.querySelector('textarea')
    const content = textarea.value
    channel.push('comments:add', {content: content})
    textarea.value = "";
  })

  channel.on(`comments:${topicId}:new`, renderComment)
  
}

function renderComments(comments) {
  console.log('connected', comments)
  const renderedComments = comments.map(commentTemplate)
  document.querySelector('.collection').innerHTML = renderedComments.join('')
}

function renderComment(event) {
  const renderedComment = commentTemplate(event.comment);
  document.querySelector('.collection').innerHTML += renderedComment;
}

function commentTemplate(comment) {

  const author = (comment.user == null) ? "Anonymous" : comment.user.email;

  return `
      <li class="collection-item">
        ${comment.content}
        <div class="right">
          ${author}
        </div>
      </li>
    `;
}

window.createSocket = createSocket
