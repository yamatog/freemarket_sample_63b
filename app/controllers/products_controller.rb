class ProductsController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def index
    @categories = Category.all.order("id ASC").limit(13)
  end

  def new
    @product = Product.new
    @product.images.build
    
    @category = Category.all.order("id ASC").limit(13)
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to root_path
    else
      render 'new'
    end    
  end

  def show
    
  end

  def edit
    @product = current_user.products.find(params[:id]).presence || "商品は存在しません"
  end

  def update
    @product = current_user.products.find(params[:id]).presence || "商品は存在しません"
    
    if @product.update(product_params)
      redirect_to product_path
    else
      render 'edit'
    end  
  end

  def destroy
    @product = current_user.products.find(params[:id])
    if @product.destroy
      redirect_to root_path
    else
      render 'show'
    end
  end

  def category_children  
    @category_children = Category.find(params[:productCategory]).children 
  end

  def category_grandchildren
    @category_grandchildren = Category.find(params[:productCategory]).children
  end

  private
  def product_params
    # binding.pry
    params.require(:product).permit(:name, :description, :status, :delivery_charge, :delivery_method, :delivery_prefecture, :delivery_days, :size, :brand, :price, :transaction_id, :category_id,
      images_attributes: {image: []}).merge(user_id: current_user.id)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def set_user
    @user = User.find(@product.user_id)
  end

end