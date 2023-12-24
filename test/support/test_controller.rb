class TestController < ActionController::Base
  def index; end
  def new; end
  def create; end
  def show; end
  def edit; end
  def updtae; end
  def destroy; end

  private

  def default_render
    render plain: "#{params[:controller]}##{params[:action]}"
  end
end
