import { LitElement, html, css } from "lit";

export class PasswordForm extends LitElement {
  static styles = css`
    :host {
      display: block;
    }
    form {
      display: flex;
      flex-direction: column;
      gap: 1rem;
    }
    div {
      display: flex;
      flex-direction: column;
    }
    label {
      font-weight: bold;
      margin-bottom: 0.25rem;
    }
    input {
      padding: 0.5rem;
      border: 1px solid #d1d5db;
      border-radius: 4px;
    }
    button {
      background-color: #3b82f6;
      color: white;
      border: none;
      padding: 0.5rem 1rem;
      border-radius: 4px;
      cursor: pointer;
    }
    button:hover {
      background-color: #2563eb;
    }
    .error {
      color: red;
    }
  `;

  render() {
    return html`
      <slot></slot>
    `;
  }
}

if (!customElements.get("password-form")) {
  customElements.define("password-form", PasswordForm);
}