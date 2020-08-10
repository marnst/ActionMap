### Credentials Management
In past version of `rails`, credentials management has been done in a variety of ways.
There are gems that were used to push credentials and environment variables across environment (eg from localhost to heroku).
In this projects, we will be using built-in `config/credentials.yml.enc` in Rails 5.2. If you are working with legacy applications,
you may encounter `Figaro`, a popular gem that is used to manage credentials.
Note, for all the following commands, make sure to `cd` into the `path/to/your/rails/app`.

1. The first step to set up your own encrypted credentials is to delete the current `config/credentials.yml.enc`
    ```shell script
    rm -rf config/credentials.yml.enc
    ```

2. Then we need to regenerate a new `config/master.key` and `config/credentials.yml.enc`.
    ```shell script
    EDITOR=vim rails credentials:edit
    ```
    Save and [exit vim](https://www.google.com/search?q=how+to+save+and+exit+vim).

3. Do not edit the `credentials.yml.enc` for now but you will later add Google Oauth, Google Civic API and Github Oauth keys.
   Just take not of the values in the file. It should look like this:
   ```yaml
   .
   .
   .
   secret_key_base: some-long-string
   ```
4. Open a rails console with `bundle exec rails c`. Inside the console, you should be able to run the following command
   and see the secret_key_base from the file.
   ```ruby
   Rails.application.credentials[:secret_key_base]
   ```
   Rails.application.credentials.dig reads the given key eg 'GOOGLE_CLIENT_ID' from
   `config/credentials.yml.enc` by decrypting it with `config/master.key`.
   You could specify environment specific groups as follows in config/credentials.yml.enc:
   ```yaml
       production:
           GOOGLE_CLIENT_ID: xxxx
           GOOGLE_CLIENT_SECRET: xxx

       development:
           GOOGLE_CLIENT_ID: xxx
           GOOGLE_CLIENT_SECRET: xxx
   ```

   Then use the following syntax to read keys for specific environment:
   ```ruby
   Rails.application.credentials.dig(:production, :GOOGLE_CLIENT_ID)
   Rails.application.credentials.dig(:development, :GOOGLE_CLIENT_ID)
   ```

### Heroku
Now we would like to setup the app on Heroku ensuring that our credentials are available there.
1. Install Heroku CLI client on your machine [using the following instructions](https://devcenter.heroku.com/articles/heroku-cli).
2. Make sure your installation works by running the following command `heroku -v` to print the version of Heroku CLI
   available on your terminal.
3. Create a new heroku app using `heroku create`. You may provide your desired appname using `heroku create fancyapp`.
   This will allow you to access your app on `fancyapp.herokuapp.com`
4. You need to add nodejs `buildpack` to your heroku app for it to work. Do so using:
   ```shell script
   heroku buildpacks:add heroku/nodejs
   heroku buildpacks:add heroku/ruby
   ```
   To confirm that you have all the buildpacks needed, run the following command:
   ```shell script
   heroku buildpacks
   ```
   You should see both ruby and nodejs in the output.
5. Next you need to enable `PostgreSQL` on heroku for your app. Run the following command:
   ```shell script
   heroku run rails db:migrate
   ```   
   In this project, you will notice in `config/database.yml` that we are using `SQLite3` for test and development
   and `PostgreSQL` for production.
6. Run the following command to make `config/credentials.yml.enc` available on heroku:
   ```shell script
   heroku config:set RAILS_MASTER_KEY=`$(< config/master.key)`
   ```
7. Now run the typical database instructions to execute migrations and seed the database.
8. You should be able to access your application using your specific `your-heroku-1234.herokuapp.com` link.
5. Now you need to update the `credentials.yml.enc` using `EDITOR=vim bundle exec rails credentials:edit`
   for login with Google and Github to work.
   Go to [console.developers.google.com](https://console.developers.google.com), click on `Credentials` and add new `OAuth 2.0 Client IDs`.
   Copy the `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` and add them to your `credentials.yml.enc`. Make sure to set your callback url using your herokuapp link
   eg. `https://your-heroku-1234.herokuapp.com/auth/google_oauth2/callback`.
   Go to [github.com/settings](https://github.com/settings), click on `OAuth apps` and add a new `OAuth App`.
   Copy the `GITHUB_CLIENT_ID` and `GITHUB_CIENT_SECRET` and add them to your `credentials.yml.enc`.
   Use this [guide to generate a Google Civic Info API key](https://developers.google.com/civic-information/docs/using_api).
   Copy they Key and add it as `GOOGLE_API_KEY`
   Your final `credentials.yml.enc` should look like:
   ```shell script
    # aws:
    #   access_key_id: 123
    #   secret_access_key: 345

    # Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
    secret_key_base: some-key

    GITHUB_CLIENT_ID: some-key
    GITHUB_CLIENT_SECRET: some-key

    GOOGLE_CLIENT_ID: some-key
    GOOGLE_CLIENT_SECRET: some-key
    GOOGLE_API_KEY: some-key
    ```
   Commit and push your changes to heroku. Wait for 10 minutes then test that login works.
   Test out your app on your phone, see if it is [responsive](https://www.w3schools.com/whatis/whatis_responsive.asp).

### Travis CI
1. Make sure you have an account with [travis-ci.com](https://travis-ci.com).
   Create the account with the Github account that you
   use for Github Classroom.
2. Install Travis CI CLI client on your terminal using the following command:
   ```shell script
   gem install travis
   ```
3. Login into Travis CI using your Github Credentials on the terminal:
   ```shell script
   travis login --pro --auto
   ```
   Afterwards, since we need to give Travis CI a means to clone our private repo to run CI builds,
   we need to generate an ssh-key for Travis to use. First identify your repo's org and name using:
   ```shell script
   git remote -v
   ```
   If the above command prints out something similar to the following:
   ```shell script
   origin  git@github.com:[myorg]/[myrepo].git
   ```
   Replace the `myorg` and `myrepo` below and run the command below.
   ```shell script
   travis sshkey --generate -r [myorg]/[myrepo]
   ```
4. Now push your `config/master.key` to Travis CI using:
   ```shell script
   travis encrypt --pro RAILS_MASTER_KEY=`cat config/master.key` --add env
   ```
5. Then run the following command to ensure your `.travis.yml` file is valid.
   ```shell script
   travis lint
   ```

### Codecov
1. Head to [codecov.io](https://codecov.io) and Click `Student` then `Sign In with Github`.
   Identify your Github Classroom project and add the repository to Codecov.

2. You may be required to add permissions to Codecov on Github. Visit the settings page on
   Github and select `Applications`. Look for Codecov and grant extra permission if so required.

3. Visit your repo on Codecov via `codecov.io/gh/[myorg]/[myrepo]/settings`.
   Identify the `Repository Upload Token` and copy the `CODECOV_TOKEN="your-codecov-upload-token"`.

4. Add this to your repo on Travis CI dashboard. In the project's Travis page, click `More Options` then `Settings`.
   Add the token to the `Environment Variables` section.
5. Add and commit your changes locally then push to Github. Head to [travis-ci.com](https://travis-ci.com)
   to try `Trigger Build` and test the CI pipeline.

6. Now replace the Travis and CodeCov badges in README.md.
   For Travis, if you click on the `build: ....` black and green badge on your repo page on Travis, you will get option to
   copy the status image.
   For Codecov, [follow these instructions](https://stackoverflow.com/questions/54010651/codecov-io-badge-in-github-readme-md)

Next, let's set up [Pivotal Tracker](./tool_setup.md).
