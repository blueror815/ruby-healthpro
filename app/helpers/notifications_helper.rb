module NotificationsHelper
  
  def comment_notification_contents(notification)
    content_tag :div, class: 'notification-element', id: "#{notification.id}" do
      concat(image_tag(notification.sender.image, class: 'img-circle img-responsive pull-left width-1') +
        content_tag(:span, notification.sender.display_name, class: 'text-primary') +
        ' commented on ' + 
        content_tag(:span, notification.notifiable.commentable.class.name.demodulize.downcase + ' #' + notification.notifiable.commentable.id.to_s, class: 'text-medium') +
        tag('br') + 
        content_tag(:span, notification.notifiable.created_at, class: 'opacity-50')
        )
    end
  end

  def notification_count
    Notification.unread_by(current_user).where.not(action: 'submit').where.not(action: 'admit_notify_payers').count + 
    (Notification.unread_by(current_user).where(action: 'submit').any? ? 1 : 0) + 
    (Notification.unread_by(current_user).where(action: 'admit_notify_payers').any? ? 1 : 0)
  end

  def summurize(notifiers)
    connectors = {
      :words_connector     => ', ',
      :two_words_connector => ' and ',
      :last_word_connector => ', and '
    }

    case notifiers.length
    when 0
      ''
    when 1
      notifiers[0].to_s.dup
    when 2
      "#{notifiers[0]}#{connectors[:two_words_connector]}#{notifiers[1]}"
    else
      "#{notifiers[0...2].join(connectors[:words_connector])}#{connectors[:last_word_connector]}#{pluralize(notifiers.length - 2, 'other')}"
    end
  end
end
