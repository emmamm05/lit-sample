import { LitElement, html, css } from "lit";

export class BackupCodes extends LitElement {
  static styles = css`
    :host {
      display: block;
    }
    p {
      margin-bottom: 0.5rem;
    }
    button {
      background-color: #3b82f6;
      color: white;
      border: none;
      padding: 0.5rem 1rem;
      border-radius: 4px;
      cursor: pointer;
      margin-bottom: 1rem;
    }
    button:hover {
      background-color: #2563eb;
    }
    div {
      margin-top: 1rem;
    }
  `;

  render() {
    return html`
      <h1>Backup codes</h1>
      <slot></slot>
    `;
  }
}

if (!customElements.get("backup-codes")) {
  customElements.define("backup-codes", BackupCodes);
}