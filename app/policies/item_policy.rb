class ItemPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(user: user)
      # TODO:  extend scope to include invited users :
      #        scope.where(user: user) + scope.where(user: user.invited_users)
    end
  end

  def show?
    record.room.flat.user == user || record.room.flat.invited_users.include?(user)
  end

  def new?
    show?
  end

  def create?
    show?
  end

  def edit?
    show?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end
end
