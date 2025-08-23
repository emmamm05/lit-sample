import { LitElement, html, css } from "lit";

export class HelloLit extends LitElement {
  static properties = {
    name: { type: String }
  };

  static styles = css`
    :host {
      display: inline-block;
      padding: 0.25rem 0.5rem;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif;
      background: #fafafa;
    }
  `;

  constructor() {
    super();
    this.name = "World";
  }

  render() {
    return html`Hello, ${this.name}!`;
  }
}

// Register the custom element so it can be used in HTML as <hello-lit>
if (!customElements.get("hello-lit")) {
  customElements.define("hello-lit", HelloLit);
}
