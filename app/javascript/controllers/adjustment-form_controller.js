import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // JSが操作するHTML要素をすべてターゲットとして登録
  static targets = [
    "isManualFixedField", 
    "paymentAmountField", 
    "displayAmount",
    "fixedButton"
  ]

  connect() {
    this.updateFixedButtonClass()
  }

  // 「金額固定」チェックボックスの処理
  toggleFixed(event) {
    event.preventDefault()
    const isCurrentlyFixed = this.isManualFixedFieldTarget.value === 'true'
    this.isManualFixedFieldTarget.value = !isCurrentlyFixed

    // 固定が解除されたら、金額をリセット
    if (!isCurrentlyFixed === false) {
      this.paymentAmountFieldTarget.value = ''
      this.displayAmountTarget.value = ''
    }
    
    this.element.requestSubmit()
  }

  // 「多め」「少なめ」などの調整ボタンの処理
  applyAdjustment(event) {
    event.preventDefault()
    const adjustmentValue = parseInt(event.currentTarget.dataset.adjustmentValue, 10)
    const currentAmount = parseInt(this.paymentAmountFieldTarget.value, 10) || 0
    const newAmount = currentAmount + adjustmentValue

    // 調整ボタンを押したら、必ず「金額固定」をオンにする
    this.isManualFixedFieldTarget.value = "true"
    this.paymentAmountFieldTarget.value = newAmount
    this.displayAmountTarget.value = newAmount

    this.element.requestSubmit()
  }

  // 金額を手入力した際の処理
  manualUpdate() {
    const newAmount = this.displayAmountTarget.value
    this.isManualFixedFieldTarget.value = "true"
    this.paymentAmountFieldTarget.value = newAmount
    this.element.requestSubmit()
  }

  // 固定ボタンの見た目を更新
  updateFixedButtonClass() {
    const isFixed = this.isManualFixedFieldTarget.value === 'true'
    if (isFixed) {
      this.fixedButtonTarget.classList.add('bg-yellow-200', 'text-yellow-800')
    } else {
      this.fixedButtonTarget.classList.remove('bg-yellow-200', 'text-yellow-800')
    }
  }
}