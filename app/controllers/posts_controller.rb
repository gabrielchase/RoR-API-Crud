class PostsController < ApplicationController
	before_action :set_post, only: [:show, :update, :destroy]
	before_action :validate_login, only: [:create]

	def index
		posts = Post.all
		if params[:filter]
			posts = posts.where(["category = ?", params[:filter]])
			posts.inspect
		end
		if params['sort']
			f = params['sort'].split(',').first
			field = f[0] == '-' ? f[1..-1] : f
			order = f[0] == '-' ? 'DESC' : 'ASC'
			if Post.new.has_attribute?(field)
				posts = posts.order("#{field} #{order}")
			end
		end
		posts = posts.page(params[:page] ? params[:page][:number] : 1)
		render json: posts, meta: pagination_meta(posts), include: ['user']
	end

	def show
		render json: @post, meta: default_meta, include: ['user']
	end

	def create
		Post.inspect
		post = Post.new(post_params)
		puts "current_user = #{@current_user.full_name}"
		post.inspect
		if post.save
			render json: post, status: :created, meta: default_meta
		else
			render_error(post, :unprocessable_entity)
		end
	end

	private
	
	def pagination_meta(object)
		{
			current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.previous_page,
      total_pages: object.total_pages,
      total_count: object.total_entries
		}
	end

	def set_post
		begin
			@post = Post.find params[:id]
		rescue ActiveRecord::RecordNotFound
			post = Post.new
			post.errors.add(:id, "Wrong ID provided")
			render_error(post, 404) and return
		end
	end

	def post_params
		ActiveModelSerializers::Deserialization.jsonapi_parse(params)
	end
end