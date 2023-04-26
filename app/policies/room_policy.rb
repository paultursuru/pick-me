class RoomPolicy < ApplicationPolicy
  # class Scope < Scope
  #   # NOTE: Be explicit about which records you allow access to!
  #   def resolve
  #     scope.where(user: user) + scope.joins(:invitations).where(invitations: { user: user }, invitations: { status: [0, 1] })
  #     # TODO:  extend scope to include invited users :
  #     #        scope.where(user: user) + scope.where(user: user.invited_users)
  #   end
  # end

  def new?
    record.flat.user == user || record.flat.invited_admin_users.include?(user)
  end

  def create?
    new?
  end

  def show?
    record.flat.user == user || record.flat.invited_accepted_users.include?(user)
  end

  def edit?
    record.flat.user == user
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end
end
