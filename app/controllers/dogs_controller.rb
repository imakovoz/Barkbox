DOGS_PER_PAGE = 5

class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy]

  # GET /dogs
  # GET /dogs.json
  def index
    # set default page to 0 for root page
    @page = params["page"].nil? ? 0 : params["page"].to_i
    @dogs = Dog.limit(DOGS_PER_PAGE).offset(DOGS_PER_PAGE * @page)
    # determine if next and prev page should be rendered
    @next_page = Dog.all.length > DOGS_PER_PAGE * (@page + 1) ? true : false
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = current_user.dogs.new(dog_params)
    respond_to do |format|
      if @dog.save
        # allow for multiple images to be passed
        if params[:dog][:image].present?
          params[:dog][:image].each { |image| @dog.images.attach(image) }
        end

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        # allow for multiple images to be passed
        if params[:dog][:image].present?
          params[:dog][:image].each { |image| @dog.images.attach(image) }
        end

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def trending_index
    # find all likes in past hour and group by dog
    # {dog_id: (count of likes)}
    @recent_likes = Like.where('created_at >= ?', 60.minutes.ago).group(:dog_id).count
    # set default page to 0 for root page
    params["page"] == nil ? @page = 0 : @page = params["page"].to_i
    @dogs = Dog.all.sort_by { |dog| @recent_likes[dog.id] || 0 }.reverse!
    @dogs = @dogs[@page*DOGS_PER_PAGE, @page*DOGS_PER_PAGE + DOGS_PER_PAGE]
    # determine if next and prev page should be rendered
    @next_page = Dog.all.length > DOGS_PER_PAGE * (@page + 1) ? true : false
    @prev_page = @page != 0 ? true : false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description, :image)
    end
end
