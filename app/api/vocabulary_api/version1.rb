class VocabularyAPI::Version1 < Grape::API
  #mount API::Version1::Users

  helpers do
    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def log_in(user)
      session[:user_id] = user.id
    end

    def logged_in?
      !current_user.nil?
    end

    def authenticate!
      error!('401 Unauthorized', 401) unless logged_in?
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    error_response(message: e.message, status: 404)
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    error_response(message: e.message, status: 422)
  end

#  mount Token
  mount Users

end
