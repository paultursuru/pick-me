class VotePolicy < ApplicationPolicy
  def create?
    record.option.item.room.flat.user == user || record.option.item.room.flat.invited_users.include?(user)
  end

  def update?
    record.user == user
  end

  def destroy?
    update?
  end
end
