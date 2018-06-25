# 의식의 흐름

### Post

- posts 컨트롤러 `rails g controller posts index new create show edit update destroy`
- post 모델 `rails g model post title:string content:text`



#### Comment

- comments 컨트롤러 `rails g controller comments index new create`
- comment 모델 `rails g model comment content:string `



### 자주쓰이는 함수 정의

```ruby
# posts_controller.rb
before_action : set_post, only:[:show, :edit, :update, :destroy]

private
def set_post
    @post = Post.find(params[:id])
end

```



### main page

```ruby
# index.html.erb
```

### new

```erb
<!-- new.html.erb -->
```



### Create

```ruby
def create 
    @post = Post.new(post_params)
    @post.save
    redirect_to "/"
end

def post_params
    params.permit(:title, :content)
end
```



### ... post CRUD 완성



### post-comment Relation 정의

```ruby
# app/models/comment.rb
class Comment < ActiveRecord::Base
  belongs_to :post
end

# app/models/post.rb
class Post < ActiveRecord::Base
  has_many :comments
end

# db/migrate/2018..._create_comments
...
    create_table :comments do |t|
      ...
      t.integer :post_id	# Foreign key
      ...   		
...
```



### 댓글 등록 form

게시글 보는 페이지에서 댓글을 바로 등록할 수 있도록 같은 페이지

```erb
<!-- app/views/posts/show.html.erb -->

<div>
  <form action="posts/<%=@post.id%>/comments" method="post">
    <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">
    <textarea name="content" rows="8" cols="80"></textarea>
    <input type="submit" name="" value="댓글등록">
  </form>
</div>
```

```ruby
# routes.rb

# post에 post_id를 가진 comment를 등록한다
post 'posts/:post_id/comments' => 'comments#create'
```



### Create

```ruby
# comments_controller.rb

def create 
    @comment = Post.find(params[:post_id]).comments.new(comment_params)
    @comment.save
    redirect_to "/posts/#{params[:id]}"
end

def comment_params
    params.permit(:content)
end
```



### Comment Show

```ruby
# posts_controller.rb 
# post에 1:N 으로 등록된 comments 를 보여주기 위해

def show
    @comments = @post.comments
end
```







# 'devise' Gem

[Getting started](https://github.com/plataformatec/devise#getting-started)

1. `devise` gem 설치

```ruby
# Gemfile
gem 'devise'
```

`$ bundle install`



2. devise 설치

   `$ rails generate devise:install`

   

```bash
$ rails generate devise:install

Running via Spring preloader in process 3215
      create  config/initializers/devise.rb
      create  config/locales/devise.en.yml
===============================================================================

Some setup you must do manually if you haven't yet:

  1. Ensure you have defined default url options in your environments files. Here
     is an example of default_url_options appropriate for a development environment
     in config/environments/development.rb:

       config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

     In production, :host should be set to the actual host of your application.

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root to: "home#index"

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

  4. You can copy Devise views (for customization) to your app by running:

       rails g devise:views

===============================================================================
```



3. user 모델 만들기

   `$ rails generate devise User`

   - `db/migrate/20180625_devise_create_users.rb`
   - `model/user.rb`
   - `config/routes.rb` : devicse_for :users



4. migration

   `$ rake db:migrate`

   

5. routes 확인

| new_user_session_path         | GET    | /users/sign_in(.:format)       | devise/sessions#new          |
| ----------------------------- | ------ | ------------------------------ | ---------------------------- |
| user_session_path             | POST   | /users/sign_in(.:format)       | devise/sessions#create       |
| destroy_user_session_path     | DELETE | /users/sign_out(.:format)      | devise/sessions#destroy      |
| user_password_path            | POST   | /users/password(.:format)      | devise/passwords#create      |
| new_user_password_path        | GET    | /users/password/new(.:format)  | devise/passwords#new         |
| edit_user_password_path       | GET    | /users/password/edit(.:format) | devise/passwords#edit        |
|                               | PATCH  | /users/password(.:format)      | devise/passwords#update      |
|                               | PUT    | /users/password(.:format)      | devise/passwords#update      |
| cancel_user_registration_path | GET    | /users/cancel(.:format)        | devise/registrations#cancel  |
| user_registration_path        | POST   | /users(.:format)               | devise/registrations#create  |
| new_user_registration_path    | GET    | /users/sign_up(.:format)       | devise/registrations#new     |
| edit_user_registration_path   | GET    | /users/edit(.:format)          | devise/registrations#edit    |
|                               | PATCH  | /users(.:format)               | devise/registrations#update  |
|                               | PUT    | /users(.:format)               | devise/registrations#update  |
|                               | DELETE | /users(.:format)               | devise/registrations#destroy |

- 회원가입 : get '/users/sign_up'
- 로그인 : get 'users/sign_in'
- 로그아웃 : delete 'users/sign_out'



6. helper method

   - `user_sign_in?`

     유저가 로그인 했는지 안했는지 true/false 리턴

   - `current_user`

     로그인되어있는 user 오브젝트를 가지고 있음

   - `before_action :authenticate_user!`

     로그인되어있는 유저 검증(필터)

   

7. View 파일 수정하기

   `$ rails generate devise:views users`