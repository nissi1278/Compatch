// app/javascript/controllers/adjustment_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["isManualFixedField", "paymentAmountField"] // ターゲット名を更新

  // 現在の表示金額を持つ要素（親要素のHTMLから探す）
  get currentDisplayAmountElement() {
    return this.element.closest(`#${this.element.id}`).querySelector('[data-participant-target="currentDisplayAmount"]');
  }

  connect() {
    this.updateFixedButtonClass();
  }

  // 固定ボタンのトグル処理
  toggleFixed(event) {
    event.preventDefault();

    const currentIsManualFixed = this.isManualFixedFieldTarget.value === 'true';
    this.isManualFixedFieldTarget.value = !currentIsManualFixed; // 固定状態をトグル
    
    if (!this.isManualFixedFieldTarget.value) { // 固定が解除された場合
      this.paymentAmountField.value = ''; // payment_amount を null にする
    } else { // 固定が有効になった場合
      // 現在表示されている金額を固定金額として設定
      this.paymentAmountField.value = parseInt(this.currentDisplayAmountElement.dataset.amount || '0');
    }

    this.element.requestSubmit();
  }

  // 「多め」「少なめ」「飲んでない」ボタンの処理
  applyAdjustment(event) {
    event.preventDefault();

    const adjustmentType = event.currentTarget.dataset.adjustmentType;
    let currentAmount = parseInt(this.currentDisplayAmountElement.dataset.amount || '0'); // 現在表示されている金額を取得

    let newPaymentAmount;

    switch (adjustmentType) {
      case 'plus': // 'plus_1000'から変更
        const plusValue = parseInt(event.currentTarget.dataset.adjustmentValue);
        newPaymentAmount = currentAmount + plusValue;
        break;
      case 'minus': // 'minus_500'から変更
        const minusValue = parseInt(event.currentTarget.dataset.adjustmentValue);
        newPaymentAmount = currentAmount + minusValue; // adjustmentValue が負の値なので加算
        break;
      case 'not_drinking':
        const baseAmount = parseInt(event.currentTarget.dataset.baseAmount || '0');
        newPaymentAmount = Math.round(baseAmount / 2); // 半額計算
        break;
      default:
        newPaymentAmount = currentAmount;
    }

    this.paymentAmountField.value = newPaymentAmount; // 計算した金額を payment_amount に設定
    this.isManualFixedFieldTarget.value = true; // 調整ボタンを押したら強制的に固定

    this.element.requestSubmit();
  }

  // 均等割に戻すボタンの処理
  resetAdjustment(event) {
    event.preventDefault();

    this.isManualFixedFieldTarget.value = false; // 固定を解除
    this.paymentAmountField.value = ''; // payment_amount を null にする

    this.element.requestSubmit();
  }

  // 固定ボタンのCSSクラスを更新
  updateFixedButtonClass() {
    const isManualFixed = this.isManualFixedFieldTarget.value === 'true';
    const fixedButton = this.element.querySelector('[data-action="click->adjustment-form#toggleFixed"]');
    if (fixedButton) {
      if (isManualFixed) {
        fixedButton.classList.add('bg-yellow-200', 'text-yellow-800');
        fixedButton.classList.remove('hover:bg-yellow-100');
      } else {
        fixedButton.classList.remove('bg-yellow-200', 'text-yellow-800');
        fixedButton.classList.add('hover:bg-yellow-100');
      }
    }
  }
}