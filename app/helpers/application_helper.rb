module ApplicationHelper
  def inline_error_for(form, attribute)
    # エラー対象のオブジェクトを取得
    object = form.object

    return unless object.respond_to?(:errors) && object.errors.key?(attribute)

    error_messages = object.errors.full_messages_for(attribute)
    tag.div class: %w[error-message text-red-600],
            data: { controller: 'auto-dismiss',
                   value: 5000 } do
      error_list = error_messages.map do |message|
        tag.li(message)
      end
      tag.ul(safe_join(error_list), class: 'list-unstyled space-y-1')
    end
  end
end
