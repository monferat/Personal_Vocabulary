class VocabularyAPI::Version1 < Grape::API

  helpers do
    def current_user
      @current_user ||= User.find_by(auth_token)
    end

    def authenticate!
      error!('401 Unauthorized', 401) unless current_user
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    error_response(message: e.message, status: 404)
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    error_response(message: e.message, status: 422)
  end

  mount Users

end
