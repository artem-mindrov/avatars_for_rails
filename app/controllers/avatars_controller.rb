#class AvatarsController < InheritedResources::Base
class AvatarsController < ApplicationController


  def index
    @avatars = Avatar.all

    respond_to do |format|
      format.html # index.html.erb
      #format.xml { render :xml => @gastos }
    end
  end
  
  def new
    @avatars = Avatar.all
    @avatar = Avatar.create(params[:avatar])
    #debugger
    
    if params[:name].blank?
      respond_to do |format|
        format.html # new.html.erb
      end
    else
      render :partial => 'precrop_drag' 
    end
    
  end

  def update
    
    if !current_subject.avatars.blank?

      new_logo = Avatar.find(params[:id])

      if (new_logo.actor == current_subject)
        actual_logo = current_subject.avatars.active.first
        if !actual_logo.blank?
          actual_logo.active = false
          actual_logo.save
        end

      new_logo.active = true
      new_logo.save
      end
    end

    redirect_to avatars_path
  end

  def create
    @avatar = Avatar.create(params[:avatar])
    
    if @avatar.new_record?
      #debugger
      
      if (params[:avatar].blank? || params[:avatar][:drag].nil?)
        render :new
      else
        render :json => {:name => File.basename(@avatar.logo.queued_for_write[:original].path) }
      end
    else
      @avatar.updating_logo = true
      @avatar.actor_id = current_subject.id
      if !current_subject.avatars.blank?
        actual_logo = current_subject.avatars.active.first
      actual_logo.active = false
      actual_logo.save
      end
      @avatar.active = true
      @avatar.save
      redirect_to avatars_path
    
    end
  end

  def current_subject
    return Actor.find(:all).first
  end
  
end
