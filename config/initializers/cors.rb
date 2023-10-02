# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:5173' # Replace with the origin(s) you want to allow

    # Allow the necessary HTTP methods
    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head]
  end
end
