const chatbox = document.getElementById("chat-input");
let dataRecieved = false;
if (chatbox) { 
  function toggleBackgroundColor(event) {
    if (event.target !== chatbox) {
      chatbox.style.backgroundColor = "#141412";
    } else {
      chatbox.style.backgroundColor = "#33332e";
    }
  }

  chatbox.addEventListener("click", toggleBackgroundColor);
  document.addEventListener("click", toggleBackgroundColor);
} else {
  console.error("Chatbox element not found. Please ensure the element has the correct ID.");
}



function github() {
window.location = "https://github.com/xaman27x";
}

function showLoading() {
  var progressBar = document.getElementById('progressbar1');
  var loader = document.getElementById('loader1');
  progressBar.classList.toggle('visible');
  loader.classList.toggle('visible');
}


function typeText(element, text, speed, index = 0) {
    if (index < text.length) {
        element.textContent += text.charAt(index);
        index++;
        setTimeout(function () {
            typeText(element, text, speed, index);
        }, speed);
    }
}
function generateDiv(text) {
  let divElement = document.createElement('div');
  divElement.style.backgroundColor = '#363332';
  divElement.style.position = 'absolute';
  divElement.style.zIndex = '1';
  divElement.style.padding = '40px';
  divElement.style.paddingTop = '80px';
  divElement.style.paddingBottom = '20px';
  divElement.style.color = 'white';
  divElement.style.maxWidth = '700px';
  divElement.style.fontFamily = 'Roboto Mono';
  divElement.style.top = '10%';
  divElement.style.left = '40%';
  divElement.style.marginBottom = '160px';
  divElement.style.overflow = 'auto'; 
  document.body.appendChild(divElement);

  // Append loader to the generated div
  let loader = document.createElement('div');
  loader.className = 'loader';
  divElement.appendChild(loader);

  // Append progress bar to the generated div
  let progressBar = document.createElement('div');
  progressBar.className = 'progressbar';
  divElement.appendChild(progressBar);

  // Call typeText function with the generated div and text
  typeText(divElement, text, 5);
}

function reply(text) {
  let divElement = document.createElement('div');
  divElement.style.backgroundColor = '#363332';
  divElement.style.position = 'absolute';
  divElement.style.zIndex = '1';
  divElement.style.padding = '40px';
  divElement.style.paddingTop = '80px';
  divElement.style.paddingBottom = '20px';
  divElement.style.color = 'white';
  divElement.style.maxWidth = '700px';
  divElement.style.fontFamily = 'Roboto Mono';
  divElement.style.top = '10%';
  divElement.style.left = '40%';
  divElement.style.marginBottom = '160px';
  divElement.style.overflow = 'auto'; 
  document.body.appendChild(divElement);
  typeText(divElement, text, 5);
}

function showLoader() {
  let loader = document.createElement('div');
  loader.className = 'loader';
  document.body.appendChild(loader);

  let progressBar = document.createElement('div');
  progressBar.className = 'progressbar';
  document.body.appendChild(progressBar);
}

function hideLoader() {
  let loader = document.querySelector('.loader');
  let progressBar = document.querySelector('.progressbar');

  if (loader) {
    loader.parentNode.removeChild(loader);
  }

  if (progressBar) {
    progressBar.parentNode.removeChild(progressBar);
  }
}

function data() {
  let prompt = document.getElementById("chat-input").value;
  fetch(`/run-data-fetch?prompt=${prompt}`)
    .then(response => response.json())
    .then(data => {
      const generatedText = data.generatedText; // Corrected property name
      generateDiv(generatedText);
    })
    .catch(error => {
      console.error('Error fetching data:', error.message);
      // Handle error as needed
    });

  sendButton.addEventListener("click", function() {
  if (dataReceived) { // Check if data has been received
    // Create and append HTML elements here
    const newParagraph = document.createElement("p");
    // ... (rest of the element creation and appending logic)
  }
});

};

var input = document.getElementById("chat-input");
input.addEventListener("keypress", function(event) {
  if (event.key === "Enter") {
    document.getElementById("information").remove();
    data();
  }
});

function chatPrompt() {
document.getElementById("information").remove();
data();
showLoading();
}



