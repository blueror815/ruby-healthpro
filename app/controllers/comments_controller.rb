class CommentsController < ApplicationController
  def create
    commentable = find_commentable
    @comment = commentable.comments.build comment_params
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        receivers = @comment.receivers - [current_user]
        notify_users_for_comment @comment, receivers
        format.js
        format.html { redirect_to :back, flash: { success: 'Comment added successfully.' } }
      else
        format.html { redirect_to :back }
      end
    end
  end

  private

  def comment_params
    params[:comment].merge! commentable_id: params[:form_datum_id] if params[:form_datum_id]
    params[:comment].merge! commentable_id: params[:visit_id] if params[:visit_id]
    params.require(:comment).permit(:content)
  end

  def find_commentable
    params.each do |name, value|
      # name = 'oncall_id' if name == 'on_call_id'
      if name =~ /(.+)_id$/ && name != "custom_form_id"
        begin
          # if name == 'visit_id' || name == 'hour_id' || name == 'on_call_id'
            # name == 'on_call_id' if name == 'oncall_id' 
            # temp = $1.classify.constantize.find(value)
          # end
          return $1.classify.constantize.find(value)
        rescue Exception => e
          return "custom_forms/#{$1}".classify.constantize.find(value)
        end
      end
    end
    nil
  end
end
