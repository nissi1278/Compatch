import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "exception" ]
    redirect(event) {
        // もしクリックされたのが「例外」の要素、またはその子要素だったら何もしない
        if (this.hasExceptionTarget && this.exceptionTarget.contains(event.target)) {
            return; // 削除ボタンが押されたので、ここから先の処理を中断
        }

        // そうでなければ、div自身が持つdata-url属性のURLに移動する
        Turbo.visit(this.element.dataset.url)
    }
}