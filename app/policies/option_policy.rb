class OptionPolicy < ApplicationPolicy
  # class Scope < Scope
  #   # NOTE: Be explicit about which records you allow access to!
  #   def resolve
  #     scope.where(user: user)
  #     # TODO:  extend scope to include invited users :
  #     #        scope.where(user: user) + scope.where(user: user.invited_users)
  #   end
  # end

  # def show?
  #   record.flat.user == user || record.flat.invited_users.include?(user)
  # end

  def new?
    record.item.room.flat.user == user || record.item.room.flat.invited_users.include?(user)
  end

  def create?
    new?
  end

  def edit?
    new?
  end

  def update?
    new?
  end

  def destroy?
    new?
  end
end
