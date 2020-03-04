class CommentPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    can_modify?
  end

  def edit?
    can_modify?
  end

  def destroy?
    can_modify?
  end

  def can_modify?
    user.id == record.user_id
  end
end
