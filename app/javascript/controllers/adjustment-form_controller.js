import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // JSが操作するHTML要素をすべてターゲットとして登録
  static targets = [
    "isManualFixedField",
    "paymentAmountField",
    "displayAmount",
    "fixedButton",
    "lockIcon",
    "unlockIcon",
    "editableElement"
  ]

  connect() {
  }

  // 「金額固定」チェックボックスの処理
  toggleFixed(event) {
    event.preventDefault()

    // 現在の状態を 'true'（文字列）と比較して取得
    const isCurrentlyFixed = this.isManualFixedFieldTarget.value === 'true'
    const isNowFixed = !isCurrentlyFixed
    this.isManualFixedFieldTarget.value = isNowFixed

    console.log(isNowFixed)
    // 新しい状態が「固定でない」場合に金額を0にリセット
    if (!isNowFixed) {
      this.paymentAmountFieldTarget.value = 0
      this.displayAmountTarget.value = 0
    }
    this.updateFormState(isNowFixed)
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

  /**
   * @private
   * アイコンの表示/非表示を切り替えるヘルパーメソッド
   */
  updateFormState(isNowFixed) {
    // アイコンの表示を切り替える
    const lockedIcon = this.lockIconTarget
    const unlockedIcon = this.unlockIconTarget

    console.log(isNowFixed)
    lockedIcon.classList.toggle('hidden', isNowFixed)
    unlockedIcon.classList.toggle('hidden', !isNowFixed)

    // 編集可能な全要素のdisabled状態を切り替える
    this.editableElementTargets.forEach((element) => {
      // isNowFixedがtrueなら有効(disabled=false)に、falseなら無効(disabled=true)にする
      element.disabled = !isNowFixed
    })
  }
}