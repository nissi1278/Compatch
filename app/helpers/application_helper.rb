module ApplicationHelper
  def inline_error_for(form, attribute)
    # エラー対象のオブジェクトを取得
    object = form.object

    return unless object.respond_to?(:errors) && object.errors.key?(attribute)

    tag.div class: %w[error-message text-red-600] do
      object.errors.full_messages_for(attribute).join(',')
    end
  end
end
