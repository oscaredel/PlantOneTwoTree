class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(twitterhandle: params[:twitterhandle])
    create_checkout_session unless @user.status == 'complete'
  end

  def new
    @user = User.new
  end

  def self.create_from_webhook(twitterhandle, tweet_author, status_id)
    @user = User.new(twitterhandle: twitterhandle, amount: 3)

    if @user.save
      request_tweet = TWITTER_REST_CLIENT.update("Hey @#{@user.twitterhandle}! @#{tweet_author} dares you to plant some trees. 🌳🌲
      Are you in? Do it here: PlantOneTwoTree.Org/#{@user.twitterhandle}", in_reply_to_status_id: status_id)
      # Save this tweets id
      @user.requesttweet = request_tweet.id
      @user.save
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save

      # TWITTER_REST_CLIENT.update("I'm tweeting with @gem!")
      user_url(@user.twitterhandle)
      redirect_to user_path(@user.twitterhandle)
    else
      render 'new'
    end
  end

  def complete
    @user = User.find_by(twitterhandle: params[:twitterhandle])
    @user.status = "complete"
    @user.save

    TWITTER_REST_CLIENT.update("You did it @#{@user.twitterhandle}! 🤩 You donated to plant #{@user.amount} trees! 🌟Awesome!
    Spread the word, let's plant a forrest together! 🌳🌲🌳", in_reply_to_status_id: @user.requesttweet)

    redirect_to user_path(@user.twitterhandle)
  end

  def edit
    @user = User.find_by(twitterhandle: params[:twitterhandle])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to user_path(@user.twitterhandle)
    else
      render 'new'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:twitterhandle, :amount)
  end

  def create_checkout_session
    @session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: {
            name: 'Plant trees',
          },
          unit_amount: 100 * @user.amount,
        },
        quantity: 1,
      }],
      mode: 'payment',
      # For now leave these URLs as placeholder values.
      #
      # Later on in the guide, you'll create a real success page, but no need to
      # do it yet.
      success_url: complete_user_url(@user.twitterhandle),
      cancel_url: user_url(@user.twitterhandle),
    })

    { id: session.id }.to_json
  end
end
