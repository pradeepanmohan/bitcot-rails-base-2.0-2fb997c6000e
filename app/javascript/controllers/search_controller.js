import { Controller } from "@hotwired/stimulus";
// import debounce from "debounce";

// export default class extends Controller {
//   initialize() {
//     this.submit = debounce(this.submit.bind(this), 300);
//   }

//   submit(_event) {
//     console.log("Hello")
//     this.element.requestSubmit();
//   }
// }

// document.addEventListener("turbo:before-stream-render", function(event) {
//   // Add a class to an element we are about to add to the page
//   // as defined by its "data-stream-enter-class"
//   if (event.target.firstElementChild instanceof HTMLTemplateElement) {
//     var enterAnimationClass = event.target.templateContent.firstElementChild.dataset.streamEnterClass
//     if (enterAnimationClass) {
//       event.target.templateElement.content.firstElementChild.classList.add(enterAnimationClass)
//     }
//   }

//   // Add a class to an element we are about to remove from the page
//   // as defined by its "data-stream-exit-class"
//   var elementToRemove = document.getElementById(event.target.target)
//   if (elementToRemove) {
//     var streamExitClass = elementToRemove.dataset.streamExitClass
//     if (streamExitClass) {
//       // Intercept the removal of the element
//       event.preventDefault()
//       elementToRemove.classList.add(streamExitClass)
//       // Wait for its animation to end before removing the element
//       elementToRemove.addEventListener("animationend", function() {
//         event.target.performAction()
//       })
//     }
//   }
// })

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input", "suggestions"];

  connect() {
    console.log("Connected?");
    document.addEventListener("click", (event) => {
      if (!this.element.contains(event.target)) {
        this.hideSuggestions();
      }
    });
  }

  suggestions() {
    const query = this.inputTarget.value;
    const url = this.element.dataset.suggestionsUrl;

    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.requestSuggestions(query, url);
    }, 250);
  }

  requestSuggestions(query, url) {
    if (query.length === 0) {
      this.hideSuggestions();
      return;
    }
    this.showSuggestions();

    fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")
          .content,
      },
      body: JSON.stringify({ query: query }),
    }).then((response) => {
      response.text().then((html) => {
        document.body.insertAdjacentHTML("beforeend", html);
      });
    });
  }

  childClicked(event) {
    this.childWasClicked = this.element.contains(event.target);
  }

  showSuggestions() {
    this.suggestionsTarget.classList.remove("hidden");
  }

  hideSuggestions() {
    if (!this.childWasClicked) {
      this.suggestionsTarget.classList.add("hidden");
    }
    this.childWasClicked = false;
  }
}