https://github.com/tyrauber/stock_quote

https://www.udemy.com/the-complete-ruby-on-rails-developer-course/learn/#/lecture/3852856

1. Create a github repository for your finance-tracker app in your github account (now you should have two github repositories, 1 for alpha-blog and 1 for finance-tracker in your github profile)
2. Push your code to your github repository so it's saved
3. Re-organize your gemfile to put sqlite3 gem in group development, test and create a group for production
4. In your production group add in gem pg (postgres) and rails_12factor to make your app heroku ready
5. Run bundle install --without production to update your .gemfile.lock file
6. Create a welcome controller, a root route for welcome#index, an index action in your welcome_controller.rb file (should be empty at this time)
<!-- 7. Create a welcome folder under your app/views/ folder and within the folder create an index.html.erb file and fill it in with <h1>Welcome to the finance tracker app</h1> -->
8. Preview your app and ensure it goes to this page in local development
9. Commit your code to your git repo
10. Push your code to your github repo
11. Create a heroku app for your application (you can reference steps taken during the alpha-blog, ensure you do this from your finance-tracker app folder)
12. Rename the heroku app to something more friendly and reasonable
13. Deploy your code to your heroku app and ensure you are able to preview the app and it takes you to the "Welcome to the finance tracker app" page
14. Post a link to your heroku app page in the discussions

<br>In your gemfile, add the devise gem:
<br>gem 'devise'
<br>Then run:
<br>bundle install --without production
<br>Then install devise in your application:
<br>rails generate devise:install
<br>rails generate devise User
<br>rake db:migrate to add users table
<br>Add the following line to the application_controller.rb file under app/controllers:
<br>before_action :authenticate_user!
<br>Add a logout link to the homepage which is the index.html.erb view under app/views/welcome folder:
<br><%= link_to "logout", destroy_user_session_path, method: :delete %>
<br>Add gem 'twitter-bootstrap-rails' in your gemfile and bundle install --without production
<br>Then run the following commands:
<br>rails generate bootstrap:install static
<br>rails g bootstrap:layout application
<br>override using Y
<br>Then add gem 'devise-bootstrap-views' in your gemfile and bundle install --without production
<br>Under your app/assets/stylesheets folder, add the following line to your application.css file above the *= require_tree . line:
<br>*= require devise_bootstrap_views
<br>Then run the following two commands from the terminal:
<br>rails g devise:views:locale en
<br>rails g devise:views:bootstrap_templates
<br>In your config/routes.rb file add the following line:
<br>devise_for :users
<br>Deploy to heroku and test out authentication by signing up some users and then logging in/out
<br>$heroku run rake db:migrate
<br>$heroku logs
<br>$heroku run rails console
<br>A problem faced here by students is after adding the before_action :authenticate_user! in the application controller, the check doesn't seem to be working. Also, the logout link may generate an error "No route matches [GET] "/users/sign_out" even with the method: :delete. If you face this error, the issue may be the following: The welcome controller was inheriting from ActionController::Base instead of ApplicationController, once you correct this it should work
<br>
