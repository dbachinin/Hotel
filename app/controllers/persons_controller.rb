class PersonsController < ApplicationController
	before_action :authenticate_user!
	def getall
		if current_user.id == 1
			# then
			@peoples = User.all
			@user = current_user
		else
			redirect_to root_path, alert: (t 'errors.messages.no_rights')
		end
	end
	def show
		@people = User.find(params[:person])
	end

	private
	def person_params
		params.require(:user).permit(:email, :login, :firstname, :lastname)
	end
end
