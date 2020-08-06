class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end

  def show
	@user = Useer.find(params[:id])
	debugger
	end
	
	def new
		@user = Useer.new
	end


end
class ApplicationController < ActionController::Base

	def home
	end

	def help
	end

	def about
	end

	def contact
	end


end
