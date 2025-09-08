import { LitElement, html, css } from "lit";

export class BackupCodesDisplay extends LitElement {
  createRenderRoot() {
    return this;
  }

  static styles = css`
    :host {
      display: block;
    }
    ul {
      list-style: none;
      padding: 0;
    }
    li {
      margin-bottom: 0.5rem;
    }
    code {
      background-color: #f3f4f6;
      padding: 0.25rem 0.5rem;
      border-radius: 4px;
      font-family: monospace;
    }
    div {
      margin-top: 1rem;
    }
    button {
      background-color: #3b82f6;
      color: white;
      border: none;
      padding: 0.5rem 1rem;
      border-radius: 4px;
      cursor: pointer;
      margin-right: 0.5rem;
    }
    button:hover {
      background-color: #2563eb;
    }
  `;

  constructor() {
    super();
    this.codesText = '';
  }

  connectedCallback() {
    super.connectedCallback();
    this.codesText = this.getCodesText();
    this.addEventListeners();
  }

  getCodesText() {
    const container = this.querySelector('#backup-codes');
    if (!container) return '';
    const items = Array.from(container.querySelectorAll('li'));
    return items.map(li => li.textContent.trim()).join('\n');
  }

  addEventListeners() {
    const copyBtn = this.querySelector('#copy-codes');
    const downloadBtn = this.querySelector('#download-codes');

    if (copyBtn) {
      copyBtn.addEventListener('click', () => {
        this.copyToClipboard(this.codesText).then(() => {
          const originalText = copyBtn.textContent;
          copyBtn.textContent = 'Copied!';
          setTimeout(() => copyBtn.textContent = originalText, 1500);
        });
      });
    }

    if (downloadBtn) {
      downloadBtn.addEventListener('click', () => {
        this.downloadText('backup-codes.txt', this.codesText);
      });
    }
  }

  copyToClipboard(text) {
    if (navigator.clipboard && window.isSecureContext) {
      return navigator.clipboard.writeText(text);
    } else {
      const ta = document.createElement('textarea');
      ta.value = text;
      ta.setAttribute('readonly', '');
      ta.style.position = 'absolute';
      ta.style.left = '-9999px';
      document.body.appendChild(ta);
      ta.select();
      try { document.execCommand('copy'); } catch (e) {}
      document.body.removeChild(ta);
      return Promise.resolve();
    }
  }

  downloadText(filename, text) {
    const blob = new Blob([text + '\n'], { type: 'text/plain;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }

  render() {
    return html`
      <h1>Your new backup codes</h1>
      <p>Store these codes securely. Each code can be used once.</p>

      <div id="backup-codes" data-download-filename="backup-codes.txt">
        <slot></slot>
      </div>

      <div>
        <button type="button" id="copy-codes">Copy to clipboard</button>
        <button type="button" id="download-codes">Download</button>
      </div>

      <p><slot name="back"></slot></p>
    `;
  }
}

if (!customElements.get("backup-codes-display")) {
  customElements.define("backup-codes-display", BackupCodesDisplay);
}