class InvitationPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(user: user)
      # TODO:  extend scope to include invited users :
      #        scope.where(user: user) + scope.where(user: user.invited_users)
    end
  end

  def new?
    record.flat.user == user || record.flat.invited_admin_users.include?(user)
  end

  def create?
    new?
  end

  def accept?
    record.user == user
  end

  def decline?
    accept? || record.flat.user == user
  end
end
