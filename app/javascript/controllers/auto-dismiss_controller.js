import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: {type: Number, default: 5000}}

  // 特定の要素を一定時間後に削除するためのコントローラ。主にエラーメッセージのflash表示のため作成。
  connect() {
    console.log('connect')
    this.startTimer()
  }

  startTimer() {
    this.timeout = setTimeout(() => {
      this.dismiss()
    }, this.delayValue)
  }

  dismiss() {
    this.element.remove()
  }
}