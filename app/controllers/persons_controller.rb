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

	def edit
	end

	def update
		 @people = User.find(params[:user][:id])
    respond_to do |format|
      if @people.update(person_params)
        format.html { redirect_to persons_show_path(person: @people.id), notice: "#{@people.login} was successfully updated." }
        format.json { render :show, status: :ok, location: @people }
      else
        format.html { render :edit }
        format.json { render json: @people.errors, status: :unprocessable_entity }
      end
    end
	end

	private
	def person_params
		params.require(:user).permit(:id, :email, :login, :firstname, :lastname, :description, :discount)
	end
end
