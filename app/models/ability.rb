# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    user ||= User.new
    #   return unless user.present?
    #   can :read, :all
    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :create, :read, :update, to: :cru

    if has_access_with_role_types?(user, 'super_admin')
      can :manage, :all
    end

    user.roles.map(&:permissions).flatten.uniq.each do |h|
      if h[:action_name] && h[:class_name]
        can string_to_action(h[:action_name]), prepare_subject(h[:class_name])
      end
    end





    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end

  protected

  def has_access_with_role_types?(user, types)
    user.roles.pluck(:role_type).include?(types)
  end

  def string_to_action(string)
    string.gsub(/^:/,'').to_sym
  end

  def prepare_subject(class_name)
    class_name.constantize
  rescue
    string_to_action(class_name)
  end
end
