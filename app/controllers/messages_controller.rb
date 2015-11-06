class MessagesController < ApplicationController
  # before_filter :authenticate_user!
  before_action :set_user, only: [:index, :show, :new, :create, :edit, :update, :destroy, :confirmation_report, :reply]
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :get_mailbox, :get_box, only: [:index, :confirmation_report]

  def index
    if @box.eql? "inbox"
      @messages = Kaminari.paginate_array(@user.get_user_inbox_messages).page params[:page]
    elsif @box.eql? "outbox"     
      @messages = Kaminari.paginate_array(@user.get_user_outbox_messages).page params[:page]
    else  
      @messages = Kaminari.paginate_array(@user.get_user_trash_messages).page params[:page]
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Mailboxer::Message.new
    @recipients = User.get_recipient_list(@user.id).map do |user|
      ["#{user.first_name} #{user.last_name}", user.id]
    end
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.xml
  def create
    recipient_ids = params[:recipients]
    recipients = User.where(id: recipient_ids)

    @receipt = @user.send_message(recipients, params[:message][:body], params[:message][:subject])
    if (@receipt.errors.blank?)
      if params[:confirm_message]
        @receipt.mark_as_unread
      end
      recipients.each do |recipient|
        GeneralUtils.push_message_notification_to_user(recipient.id)
      end
      redirect_to messages_path(box: "outbox")
    else
      render :action => :new
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
  end

  # POST /messages/:id/reply
  def reply
    response = {errors: false}
    message = Mailboxer::Message.find(params[:id].to_i)
    receipt = message.receipts.where(receiver_id: message.sender.id).first

    if params[:body] && @user.reply_to_sender(receipt, params[:body])
      response[:message_id] = message.id.to_s
      GeneralUtils.push_message_notification_to_user(receipt.receiver_id)
    else
      response[:errors] = true
    end

    render :json => response
  end

  # GET /confirmation_report
  def confirmation_report
    initial_receipts = Mailboxer::Receipt.all.where(receiver_id: @user.id, is_read: false)
    
    if initial_receipts.present? && initial_receipts.count > 0
      proper_receipts = []
      initial_receipts.each do |receipt|
        if receipt.message.sender_id == @user.id
          proper_receipts << receipt
        end
      end

      if proper_receipts.present? && proper_receipts.count > 0
        @messages = User.get_messages_from_receipts_for_confirmation(proper_receipts)
        @receipts = User.get_message_receipts_for_message_confirmation(@messages, @user) 
      else
        @messages = []
      end
    else
      @messages = []
    end
  end

  # GET /messages/all_agents
  def get_all_agents
    response = {errors: false}
    all_agents = User.get_all_agent_ids(current_user.id)
    if all_agents.present? && all_agents.length > 0
      response[:all_agents] = all_agents
    else
      response[:errors] = true
    end

    render :json => response
  end

  # GET /messages/all_managers
  def get_all_managers
    response = {errors: false}
    all_managers = User.get_all_manager_ids(current_user.id)
    if all_managers.present? && all_managers.length > 0
      response[:all_managers] = all_managers
    else
      response[:errors] = true
    end

    render :json => response
  end

  # GET /messages/:id/read
  def check_mark_as_read
    response = {marked: false}
    message = Mailboxer::Message.find(params[:id])
    receipt = message.receipts.where(receiver_id: current_user.id).first
    no_confirmation_required = message.receipts.where(receiver_id: message.sender.id).first.is_read

    if !receipt.is_read && no_confirmation_required && receipt.mark_as_read 
      GeneralUtils.push_message_notification_to_user(current_user.id)
      response[:marked] = true
    end

    render :json => response
  end

  # POST /messages/move_checked_to_trash
  def move_checked_to_trash
    response = {errors: false}
    messages = Mailboxer::Message.where(id: params[:ids])
    ids = []
    if current_user && messages.present? && messages.count > 0
      messages.each do |message|
        if message.move_to_trash(current_user)
          ids << message.id.to_s
        end
      end
      response[:ids] = ids
    else
      response[:errors] = true
    end

    render :json => response
  end

  # POST /messages/confirm_message
  def confirm_message
    response = {errors: false, marked: false, message_id: "0"}

    message = Mailboxer::Message.find(params[:id])
    receipt = message.receipts.where(receiver_id: current_user.id).first
    no_confirmation_required = message.receipts.where(receiver_id: message.sender.id).first.is_read
    
    if !receipt.is_read && !no_confirmation_required && receipt.mark_as_read
      GeneralUtils.push_message_notification_to_user(current_user.id)
      response[:marked] = true
      response[:message_id] = message.id.to_s
    end

    render :json => response
  end

  # /safe_destroy
  def safe_destroy
    response = {errors: false}
    messages = Mailboxer::Message.where(id: params[:ids])
    ids = []
    if current_user && messages.present? && messages.count > 0
      messages.each do |message|
        if message.mark_as_deleted(current_user)
          ids << message.id.to_s
        end
      end
      response[:ids] = ids
    else
      response[:errors] = true
    end

    render :json => response
  end

  private

  def set_user
    @user = current_user
  end

  def set_message
    @message = Mailboxer::Message.find(params[:id])
  end

  def get_mailbox
    @mailbox = current_user.mailbox
  end

  def get_box
    if params[:box].blank? or !["inbox","outbox","trash"].include?params[:box]
      @box = "inbox"
    return
    end
    @box = params[:box]
  end
 
end
