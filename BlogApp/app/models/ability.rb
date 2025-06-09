# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    else
      can :read, Article, public: true
      can :create, Article
      can [:read, :update, :destroy], Article, user: user
      can :create, Report
      can :read, Report, user: user
    end
  end
end
