class ApplicationController < ActionController::API
	before_action :check_header

	private

	def check_header
		puts "in check_header"
		puts "========="
		puts request.method
		puts request.content_type 
		puts "========="
		if ['POST', 'PUT', 'PATCH'].include? request.method
			if request.content_type != "application/json"
				head 406 and return
			end
		end
	end

	def validate_type
		# puts params['data']
		# puts params['data']['type']
		# puts params[:controller]
		if params['data'] && params['data']['type']
			if params['data']['type'] == params[:controller]
				return true
			end 
		end
		head 409 and return
	end

	def validate_user
		puts "in validate_user"
		token = request.headers["X-Api-Key"]
		head 403 and return unless token
		user = User.find_by token: token
		head 403 and return unless user
	end

	def render_error(resource, status)
		render json: resource, status: status, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
	end
end
