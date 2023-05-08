class FlatPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(user: user) + scope.joins(:invitations).where(invitations: { user: user }, invitations: { status: [0, 1] })
      # TODO:  extend scope to include invited users :
      #        scope.where(user: user) + scope.where(user: user.invited_users)
    end
  end

  def new?
    user.present?
  end

  def create?
    new?
  end

  def edit?
    record.user == user
  end

  def update?
    edit?
  end

  def show?
    record.user == user || record.invited_accepted_users.include?(user)
  end

  def destroy?
    edit?
  end
end
