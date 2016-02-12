Social Network
================

App link: https://young-shore-82576.herokuapp.com/
A small social network with real-time chat, albums, groups, comments, likes and dislikes made in Ruby on Rails and
deployed on Heroku.

Gems
----------------
- devise - for authentication, user management and email account confirmation
- cancancan - for authorization in controllers and views
- groupify - for easy group creation and management with different user groups
- paperclip - for managing uploads of images and albums to app
- public_activity - for loging activity of users and displaying records about them in app as wall statuses etc.
- has_friendship - for creating and managing friendships, friendship confirmations
- private_pub - for enabling websocket functionality, subsribing to channels on Faye server
- thin - for replacing Webrick as default server, due to dufficulties with private_pub on Webrick
- and various others little gems

Installation
----------------
to run the Thin server run:
`````````````````````
rails s
`````````````````````
We are using Postgres as our DB in production and developement enviroments, so you have to have postgres installed
and app database created before migrating. Database names can be found in config/database.yml. To migrate run:
````````````````````
rake db:migrate
````````````````````
If you want to have live chat and other web-socket functionality you have to run Faye server. To do that run:
````````````````````
rackup private_pub.ru -s thin -E production
````````````````````
Deployment
----------------
If you are deploying this to heroku, there is no easy and free way to make both Thin and Faye work in the same app. Best
solution for this is to create a separate Heroku app for your Faye server. Example code for that can be found here:
https://github.com/Hareramrai/fayeserver. You have to adjust config variables so both apps share same key.