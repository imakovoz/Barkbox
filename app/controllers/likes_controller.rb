class LikesController < ApplicationController
  before_action :set_like, only: [:destroy]

  # POST /likes
  # POST /likes.json
  def create
    current_user.likes.new(like_params)

    respond_to do |format|
      if @like.save
        format.html { redirect_to request.referrer, notice: 'Like was successfully created.' }
        format.json { render :show, status: :created, location: @like }
      else
        format.html { render :new }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /likes/1
  # DELETE /likes/1.json
  def destroy
    @like.destroy
    respond_to do |format|
      format.html { redirect_to request.referrer, notice: 'Like was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def like_params
      params.permit(:dog_id)
    end
end

