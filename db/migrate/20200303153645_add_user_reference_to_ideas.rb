class AddUserReferenceToIdeas < ActiveRecord::Migration[6.0]
  def change
    add_reference :ideas, :user, foreign_key: true
    Idea.update_all(user_id: User.first&.id)
  end
end
