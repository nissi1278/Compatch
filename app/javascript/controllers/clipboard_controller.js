import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  copy(event) {
    event.preventDefault()
    // クリップボードにURLを書き込む
    navigator.clipboard.writeText(this.urlValue).then(() => {
      // 3. (オプション) ユーザーにフィードバックする
      const originalText = this.element.innerText
      this.element.innerText = "コピーしました！"
      this.element.disabled = true

      setTimeout(() => {
        this.element.innerText = originalText
        this.element.disabled = false
      }, 2000)
  })
  }
}