module K3
  module Blog
    class BaseController < ApplicationController

      # Needed for CanCan authorization
      include CanCan::ControllerAdditions

      def current_ability
        @current_ability ||= K3::Blog::Ability.new(k3_user)
      end

      rescue_from CanCan::AccessDenied do |exception|
        k3_authorization_required
      end

      helper K3::InlineEditor::InlineEditorHelper

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
