https://github.com/tyrauber/stock_quote

https://www.udemy.com/the-complete-ruby-on-rails-developer-course/learn/#/lecture/3852856

1. Create a github repository for your finance-tracker app in your github account (now you should have two github repositories, 1 for alpha-blog and 1 for finance-tracker in your github profile)
2. Push your code to your github repository so it's saved
3. Re-organize your gemfile to put sqlite3 gem in group development, test and create a group for production
4. In your production group add in gem pg (postgres) and rails_12factor to make your app heroku ready
5. Run bundle install --without production to update your .gemfile.lock file
6. Create a welcome controller, a root route for welcome#index, an index action in your welcome_controller.rb file (should be empty at this time)
7. Create a welcome folder under your app/views/ folder and within the folder create an index.html.erb file and fill it in with <h1>Welcome to the finance tracker app</h1>
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
<br>Remove the sidebar div from the application.html.erb file under app/views/layouts folder
<br>Remove(or code out) the following code for forgot your password link from the _links.html.erb partial under the app/views/devise/shared folder:
<%- if devise_mapping.recoverable? && controller_name != 'passwords' %>
<%= link_to t(".forgot_your_password", :default => "Forgot your password?"), new_password_path(resource_name)
%><br />
<% end -%>
<br>rails g model Stock ticker:string name:string last_price:decimal
<br>Create the table by running the migration:
<br>rake db:migrate
<br>Add gem 'stock_quote' to your gemfile and run bundle install --without production
<br>Hop on rails console to get stock price for a stock:
<br>StockQuote::Stock.quote("symbol").open
<br>StockQuote::Stock.quote("symbol").previous_close
<br>Now need to add a view page for my portfolio, we'll call it my portfolio, so go to config/routes.rb file and add in the following route:
<br>get 'my_portfolio', to: 'users#my_portfolio'
<br>Create a users_controller.rb file under app/controllers and add in my_portfolio action:
<br>class UsersController < ApplicationController
def my_portfolio
end
end
<br>under views add users folder and under it create a my_portfolio.html.erb file and fill it in:
<h1>My Portfolio</h1>
<br>change routes
<br>  get 'welcome_index', to: 'welcome#index'
<br>  root 'users#my_portfolio'
<br>
<br>Now we will add the two class level methods to the stock.rb model
<br>file under app/models folder and an third price method:
<br>def self.find_by_ticker(ticker_symbol)
<br>where(ticker: ticker_symbol).first
<br>end
<br>def self.new_from_lookup(ticker_symbol)
<br>looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
<br>return nil unless looked_up_stock.name
<br>new_stock = new(ticker: looked_up_stock.symbol, name:
<br>looked_up_stock.name)
<br>new_stock.last_price = new_stock.price
<br>new_stock
<br>end
<br>def price
<br>closing_price = StockQuote::Stock.quote(ticker).close
<br>return "#{closing_price} (Closing)" if closing_price
<br>opening_price = StockQuote::Stock.quote(ticker).open
<br>return "#{opening_price} (Opening)" if opening_price
<br>'Unavailable'
<br>end
<br>We are adding the self. prior to the method name, because these methods are not tied to any objects or object lifecycle, we need to be able to use them without having any instances of a stock.
<br>First add a route to your config/routes.rb file to search stocks:
<br>get 'search_stocks', to: 'stocks#search'
<br>Now we add a stocks_controller.rb file under app/controllers and within it we define a search method. We are putting the search method in the stocks_controller because we want to have an easy way to search for stocks from our view, so we'll call it from there:
<br>class StocksController < ApplicationController
<br>def search
<br>if params[:stock]
<br>@stock = Stock.find_by_ticker(params[:stock])
<br>@stock ||= Stock.new_from_lookup(params[:stock])
<br>end
<br>if @stock
<br>render partial: 'lookup'
<br>else
<br>render status: :not_found, nothing: true
<br>end
<br>end
<br>end
<br>To temporarily view output from the browser, code out the render partial: 'lookup' line and add in the following line under it:
<br>render json: @stock
<br>Now we will create the lookup partial, create a stocks folder under app/views folder and within it create a file named _lookup.html.erb
<br>a. build the form_tag
<br><div id="stock-lookup">
<br><h3>Search for Stocks</h3>
<br><%= form_tag search_stocks_path, remote: true, method: :get, id: 'stock-lookup-form' do %>
<br><div class="form-group row no-padding text-center col-md-12">
<br><div class="col-md-10">
<br><%= text_field_tag :stock,
<br>params[:stock],
<br>placeholder: 'Stock Ticker Symbol',
<br>autofocus: true,
<br>class: 'form-control search-box input-lg' %>
<br></div>
<br><div class="col-md-2">
<br><%= button_tag(type: :submit, class: 'btn btn-lg btn-success') do %>
<br><i class='fa fa-search'></i> Look up a stock
<br><% end %>
<br></div>
<br></div>
<br><% end %>
<br></div>
<br>Go to my_portfolio.html.erb under app/views/users and add the following line just to show the form:
<br><%= render 'stocks/lookup' %>
<br>Now lets add the rest of the code to the lookup partial under app/views/stocks folder->
<br>So if we have @stock instance variable then we want to do something with it, add the code below under the <% end %> and above the last
<br><% if @stock %>
<br><div id="stock-lookup-results" class="well results-block">
<br><strong>Symbol:</strong> <%= @stock.ticker %>
<br><strong>Name:</strong> <%= @stock.name %>
<br><strong>Price:</strong> <%= @stock.price %>
<br></div>
<br><% end %>
<br>
<br>Now that we have the id's and the form that submits via ajax, we want to handle the return of that ajax action so we create a stocks.js file in app/assets/javascripts folder
<br>$(document).ready(function() {
<br>init_stock_lookup();
<br>})
<br>then above it we type in:
<br>var init_stock_lookup;
<br>init_stock_lookup = function(){
<br>$('#stock-lookup-form').on('ajax:success', function(event, data, status){
<br>$('#stock-lookup').replaceWith(data);
<br>init_stock_lookup();
<br>});
<br>}
<br>You need to add the init_stock_lookup(); again since the listeners are gone once you replace with the data that's returned so you have to re-initialize it.
Now go to my_portfolio URL from the browser and test out a few stock symbols
<br>Next create a custom.css.scss file under app/assets/stylesheets folder and add some styling:
<br>.results-block {
<br>display: inline-block;
<br>}
<br>Now next thing we want to handle are errors, add the following to stocks.js file above the closing } for the init_stock_lookup = function()
<br>$('#stock-lookup-form').on('ajax:error', function(event, xhr, status, error){
<br>$('#stock-lookup-results').replaceWith('');
<br>$('#stock-lookup-errors').replaceWith('Stock was not found.');
<br>});
<br>Add the following to lookup partial after the <% end %> and above the last </div>:
<br><div id="stock-lookup-errors"></div>
<br>
<br>
<br>
<br>
<br>
