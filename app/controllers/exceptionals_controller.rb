class ExpectedError < RuntimeError;end

class ExceptionalsController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :require_login

  def show

  end


  def an_exception
    @exception = ExpectedError.new "Help I'm being oppressed!"
    raise @exception
  end

  def rendered_exception
    render json: {a: 1, b: 2}
    raise ExpectedError.new 'Not Again!'
  end
end
