# README

Add design using HTML & CSS
- Do not delete unwanted scaffold

Additional:
- Authorization
- Validations, and validation error messages style

Tips:
- If database cant be droped due to lack of permisions use rake db:drop:_unsafe
- After instaling ImageMagic close the terminal and start rails server again
- Atom plugin - autosave-onchange

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
