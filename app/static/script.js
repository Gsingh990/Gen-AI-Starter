const chatBox = document.getElementById('chat-box');
const userInput = document.getElementById('user-input');
const sendButton = document.getElementById('send-button');

sendButton.addEventListener('click', sendMessage);
userInput.addEventListener('keypress', (event) => {
    if (event.key === 'Enter') {
        sendMessage();
    }
});

function sendMessage() {
    const userMessage = userInput.value;
    if (userMessage.trim() === '') {
        return;
    }

    appendMessage('user', userMessage);
    userInput.value = '';

    fetch('/query/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ text: userMessage })
    })
    .then(response => response.json())
    .then(data => {
        appendMessage('bot', data.response);
    })
    .catch(error => {
        console.error('Error:', error);
        appendMessage('bot', 'Sorry, something went wrong.');
    });
}

function appendMessage(sender, message) {
    const messageElement = document.createElement('div');
    messageElement.classList.add(sender + '-message');

    const bubbleElement = document.createElement('div');
    bubbleElement.classList.add('message-bubble');
    bubbleElement.textContent = message;

    messageElement.appendChild(bubbleElement);
    chatBox.appendChild(messageElement);
    chatBox.scrollTop = chatBox.scrollHeight;
}