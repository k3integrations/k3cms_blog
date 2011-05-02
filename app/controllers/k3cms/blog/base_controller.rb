module K3cms
  module Blog
    class BaseController < ApplicationController

      include CanCan::ControllerAdditions
      helper K3cms::InlineEditor::InlineEditorHelper

      def current_ability
        @current_ability ||= K3cms::Blog::Ability.new(k3cms_user)
      end

      rescue_from CanCan::AccessDenied do |exception|
        k3cms_authorization_required(exception)
      end

    protected
      # Unfortunately, FriendlyId raises an error for some things instead of just adding a validation error to the errors array.
      # Let's try to respond the same as we would for a validation error though.
      rescue_from ::FriendlyId::BlankError, :with => :rescue_friendly_id_blank_error

      def rescue_friendly_id_blank_error
        respond_to do |format|
          format.json { render :json => {:error => 'Cannot be blank'} }
        end
      end

    end
  end
end
