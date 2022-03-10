class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :move_to_index, only: :edit
  
  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end
    
  def show
    @prototype = set_prototype
    @comment = Comment.new
    @comments = @prototype.comments
  end

  def edit
    @prototype = set_prototype
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      render :edit
    end
  end

  def destroy
    prototype = set_prototype
    prototype.destroy
    redirect_to root_path
  end

  # ここから下はprivate ////////////////////////////////////////////////////////////////////////////////
  private

  def prototype_params
    return params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    return Prototype.find(params[:id])
  end

  def move_to_index
    unless current_user.id == Prototype.find(params[:id]).user.id
      redirect_to action: :index
    end
  end
end
