class AddUserReferenceToComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :user, foreign_key: true
    remove_column :comments, :user_name, :string
    Comment.update_all(user_id: User.first&.id)
  end
end
