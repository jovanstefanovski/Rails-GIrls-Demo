# README

TODO:
- Comment modifications tutorial, make comments nested, remove index routes
- Design changes tutorial, Update desigh guide with the new changes, Do not delete unwanted scaffold
- Validations, and validation error messages style

Tips:
- If database cant be droped due to lack of permisions use rake db:drop:_unsafe
- After instaling ImageMagic close the terminal and start rails server again
- Atom plugin - autosave-onchange
- Add public folder to gitignore

### Associate users with ideas and comments

* Ideas:
1. Add user_id to ideas:
    - Run ```rails g migration add_user_reference_to_ideas user:references``` command
    - Open the new migration and replace ```add_reference :ideas, :user, null: false, foreign_key: true``` with ```add_reference :ideas, :user, foreign_key: true```
    - After the previus line add ```Idea.update_all(user_id: User.first&.id)```
    - Run ```rails db:migrate``` command
2. Add associations to the models:
    - Open idea.rb and at the end of the file before ```end``` add ```belongs_to :user```
    - Open user.rb and at the end of the file before ```end``` add ```has_many :ideas```
3. When creating a new idea set the current user as the user of the idea.
    - Open ideas_controller.rb and in create action after ```@idea = Idea.new(idea_params)``` add ```@idea.user = current_user```
4. Modify the views to show the email of the user that created the idea
    - Open views/ideas/show.html.erb and after ```<p class='wrap_word'><%= @idea.description %></p>``` add ```<p><b>Idea by: </b><%= @idea.user.email %></p>```
    - Open views/ideas/index.html.erb and after ```<p class='wrap_word'><%= idea.description %></p>``` add ```<p><b>Idea by: </b><%= idea.user.email %></p>```
    
* Comments:
1. Add user_id to comments and remove the username column:
    - Run ```rails g migration add_user_reference_to_comments user:references``` command
    - Open the new migration and replace ```add_reference :comments, :user, null: false, foreign_key: true``` with ```add_reference :comments, :user, foreign_key: true```
    - After the previus line add ```Comment.update_all(user_id: User.first&.id)```
    - After the previous line add ```remove_column :comments, :user_name, :string```
    - Run ```rails db:migrate``` command
2. Add associations to the models:
    - Open comment.rb and at the end of the file before ```end``` add ```belongs_to :user```
    - Open user.rb and at the end of the file before ```end``` add ```has_many :comments```
3. When creating a new comment set the current user as the user of the comment.
    - Open comments_controller.rb and in create action after ```@comment = Comment.new(comment_params)``` add ```@comment.user = current_user```
4. Modify the views to show the email of the user that created the comment
    - Open views/ideas/show.html.erb and change the ```<strong><%= comment.user_name %></strong>``` line with ```<strong><%= comment.user.email %> commented</strong>```
    - Open views/comments/_form.html.erb and remove the following code 
      ```
      <div class="field">
        <%= form.label :user_name %>
        <%= form.text_area :user_name, class: "form-control" %>
      </div>
      ```


### Authorization

1. In Gemfile under ```gem 'gravtastic'``` add ```gem 'pundit'```
2. Run ```bundle install``` command
3. Run ```rails g pundit:install```. This will create a new 'policy' folder, and a new application_policy.rb' file.
4. Open application_controller.rb and after ```before_action :authenticate_user!``` add ```include Pundit```
5. Add authorization in controllers:
* Open ideas_controller.rb
    - Add ```authorize Idea``` at the beginning of the index, new and create action.
    - Add ```authorize @idea``` at the beginning of the show, edit, update and destroy action.
* Open comments_controller.rb
    - Add ```authorize Comment``` at the beginning of the create action.
    - Add ```authorize @comment``` at the beginning of the edit, update and destroy action.
6. Create policies/idea_policy.rb file and add the following code:
```
class IdeaPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
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
```
7. Create policies/comment_policy.rb and add the following code:
```
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
```
7. Handle authorization error.
Open application_controller.rb and after ```include Pundit``` add the following code:
```
rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

private

def user_not_authorized
  flash[:alert] = "You are not authorized to perform this action."
  redirect_to(request.referrer || root_path)
end
```
8. Modify idea show view to not show the 'Edit' and 'Destroy' links if the user is not authorized fot those actions.
    - Open views/ideas/show.html.erb
    - Replace the following code:
    ```
    <%= link_to 'Edit', edit_idea_path(@idea) %> |
    <%= link_to 'Destroy', @idea, data: { confirm: 'Are you sure?' }, method: :delete %> |
    ```
    With:
    ```
    <% if policy(@idea).edit? %>
      <%= link_to 'Edit', edit_idea_path(@idea) %> |
    <% end %>
    <% if policy(@idea).destroy? %>
      <%= link_to 'Destroy', @idea, data: { confirm: 'Are you sure?' }, method: :delete %> |
    <% end %>
    ```
    - Replace the followin code:
    ```
    <p><%= link_to 'Delete', comment_path(comment), method: :delete, data: { confirm: 'Are you sure?' } %></p>
    <p><%= link_to 'Edit', edit_comment_path(comment) %></p>
    ```
    With:
    ```
    <% if policy(comment).destroy? %>
      <%= link_to 'Delete', comment_path(comment), method: :delete, data: { confirm: 'Are you sure?' } %> |
    <% end %>
    <% if policy(comment).destroy? %>
      <%= link_to 'Edit', edit_comment_path(comment) %>
    <% end %>
    ```
