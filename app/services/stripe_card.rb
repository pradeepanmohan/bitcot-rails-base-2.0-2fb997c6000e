class StripeCard

  attr_accessor :customer

  # @param [User] user
  def initialize(user)
    @user = user
    if user.stripe_customer_id.blank?
      @customer = nil
    else
      @customer = Stripe::Customer.retrieve(user.stripe_customer_id)
    end
  end

  def create_customer(token)
    begin
      @customer = Stripe::Customer.create(
          email: @user.email,
          source: token,
          metadata: {
              name: @user.decorate.full_name,
              id: @user.id
          }
      )
    rescue Exception => e
      return false, e.message
    end

    @user.update_attribute(:stripe_customer_id, @customer.id)
    return true
  end

  def create!(token)
    begin
      card = @customer.sources.create({source: token})
    rescue Exception => e
      return false, e.message
    end

    if card.cvc_check == 'fail'
      delete_all_cards
      return false, 'Stripe CVC check failed'
    end
    @customer.default_source = card.id
    @customer.save
    to_hash(card)
  end

  def default_card
    if default_source = @customer.default_source
      card = @customer.sources.retrieve(default_source)
      to_hash(card)
    else
      nil
    end
  end

  def get_card(card_id)
    card = @customer.sources.retrieve({id: card_id})
    to_hash(card)
  end

  def all_cards
    list_data = Stripe::Customer.list_sources(
        @customer.id,
        {object: 'card'},
    )
    cards = list_data.data || []
    card_data = []
    cards.each do |card|
      card_data << to_hash(card)
    end
    card_data
  end

  #delete a specific card
  def delete_card(card_id)
    @customer.sources.retrieve({id: card_id}).delete
  end

  #delete all credit card except the default credit card
  def delete_inactive_cards
    cards = @customer.sources.data || []
    cards.each do |card|
      delete_card(card.id) unless card.id == @customer.default_source
    end
  end

  def delete_all_cards
    cards = @customer.sources.data || []
    cards.each {|card| delete_card(card.id)}
  end

  def reload!
    @user.reload
    if @user.stripe_customer_id.blank?
      @customer = nil
    else
      @customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
    end
  end

  def customer_available?
    !@customer.blank?
  end

  def validate_card
    customer = @user.stripe_customer_id
    return false unless default_card
    return true, customer
  end

  def update_card(card_id , card_name)
    Stripe::Customer.update_source(@user.stripe_customer_id, card_id, {name: card_name})
  end


  def to_hash(card)
    card_data = {}
    unless card.blank?
      card_data[:id] = card.id
      card_data[:last4] = card.last4
      card_data[:exp_month] = card.exp_month
      card_data[:exp_year] = card.exp_year
      card_data[:default] = card.id == @customer.default_source
      card_data[:name] = card.name
      card_data[:brand] = card.brand
      card_data[:address_city] = card.address_city
      card_data[:address_country] = card.address_country
      card_data[:address_line1] = card.address_line1
      card_data[:address_line1_check] = card.address_line1_check
      card_data[:address_line2] = card.address_line2
      card_data[:address_state] = card.address_state
      card_data[:address_zip] = card.address_zip
      card_data[:address_zip_check] = card.address_zip_check
      card_data[:country] = card.country
    end
    card_data
  end

end