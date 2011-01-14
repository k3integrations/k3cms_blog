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
    end
  end
end
