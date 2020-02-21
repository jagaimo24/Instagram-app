module NotificationsHelper
  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end

  def notification_form(notification)
    @comment = nil
    case notification.action
      when "follow" then
        "あなたをフォローしました"
      when "like" then
        "あなたの投稿にいいね！しました"
      when "comment" then
        @comment = Comment.find_by(id:notification.comment_id)&.content
        if current_user.id == notification.micropost.user.id
          "あなたの投稿にコメントしました"
        else
          "#{notification.micropost.user.name}さんの投稿にコメントしました"
        end
    end
  end
end
