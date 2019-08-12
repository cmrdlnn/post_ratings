# frozen_string_literal: true

require Rails.root.join('lib', 'json_web_token')

class ApplicationController < ActionController::API
  around_action :handle_exceptions

  NotAuthorized = Class.new(StandardError)

  def handle_exceptions
    yield
  rescue StandardError => e
    status, message = extract_error_info(e)
    handle_error(e, message, status)
  end

  STANDARD_HANDLER = proc { |e| { error: e.message } }.freeze

  SERVER_ERROR = { error: 'Server error' }.freeze

  SERVER_ERROR_HANDLER = proc { SERVER_ERROR }

  ERROR_INFOS = {
    NotAuthorized                          => [401, STANDARD_HANDLER],
    ActiveRecord::RecordNotFound           => [404, STANDARD_HANDLER],
    ActiveRecord::RecordInvalid            => [422, STANDARD_HANDLER],
    ActiveRecord::RecordNotUnique          => [409, STANDARD_HANDLER],
    ActiveRecord::StatementInvalid         => [422, STANDARD_HANDLER],
    ActionController::ParameterMissing     => [422, STANDARD_HANDLER],
    Base::Validator::Errors::InvalidParams => [422, :info.to_proc],
    ArgumentError                          => [422, STANDARD_HANDLER],
    StandardError                          => [500, SERVER_ERROR_HANDLER]
  }.freeze

  private

  def extract_error_info(error)
    error_class = ERROR_INFOS.each_key.find(&error.method(:is_a?))
    error_info = ERROR_INFOS[error_class] || return
    [error_info.first, error_info.last.call(error)]
  end

  def handle_error(exception, message, status = 500)
    Rails.logger.error { "#{exception.class}: #{exception.message}" }
    Rails.logger.error { sanitize_backtrace(exception) } if status == 500
    render json: message, status: status
  end

  def sanitize_backtrace(exception)
    exception.backtrace.grep(%r{^#{Rails.root}\/}).join("\n")
  end

  attr_reader :user

  def auth!
    user_id = JSONWebToken.decode(eject_token).first['id']
    @user = User.find(user_id)
  rescue JWT::DecodeError => e
    raise NotAuthorized, "Invalid authorization token: #{e.message}"
  rescue ActiveRecord::RecordNotFound
    raise NotAuthorized, 'User not found'
  end

  def eject_token
    auth_header = request.headers['Authorization']
    raise NotAuthorized, 'Authorization header not provided' unless auth_header
    token = auth_header.split(' ').last
    return token if token.present?
    raise NotAuthorized, 'Invalid Authorization header structure'
  end
end
